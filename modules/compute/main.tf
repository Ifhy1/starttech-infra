# 1. Automatically find the latest Ubuntu 22.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# 2. Security Group for the Load Balancer (The Entrance)
resource "aws_security_group" "alb_sg" {
  name   = "alb_sg_modular"
  vpc_id = var.vpc_id
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. Security Group for the Server (The House)
resource "aws_security_group" "backend_sg" {
  name   = "backend_sg_modular"
  vpc_id = var.vpc_id

  # Allows traffic from the Load Balancer
  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # Allows your browser to visit the IP directly
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 4. The EC2 Instance
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = var.public_subnet_1 
  
  vpc_security_group_ids = [aws_security_group.backend_sg.id]

  # This script installs a web server so the page isn't blank
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y apache2
              sudo systemctl start apache2
              sudo systemctl enable apache2
              echo "<h1>Infrastructure Modularization Success!</h1><p>Your modular Terraform project is live.</p>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "MuchTodo-Server"
  }
}

# 1. The Application Load Balancer
resource "aws_lb" "backend_alb" {
  name               = "muchtodo-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.backend_sg.id] 
  subnets            = [var.public_subnet_1, var.public_subnet_2] # Needs two AZs!

  tags = { Name = "MuchTodo-ALB" }
}

# 2. The Target Group (The "Bucket" for your EC2 instances)
resource "aws_lb_target_group" "backend_tg" {
  name     = "muchtodo-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# 3. The Listener (Listening on Port 80)
resource "aws_lb_listener" "backend_listener" {
  load_balancer_arn = aws_lb.backend_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }
}

# 4. Attach your EC2 instance to the Target Group
resource "aws_lb_target_group_attachment" "backend_attach" {
  target_group_arn = aws_lb_target_group.backend_tg.arn
  target_id        = aws_instance.web.id
  port             = 80
}