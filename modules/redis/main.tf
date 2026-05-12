# 1. Security Group for Redis (Only allows the Backend to talk to it)
resource "aws_security_group" "redis_sg" {
  name   = "redis_sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [var.backend_sg_id] # Only the backend server can enter
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. Redis Subnet Group (Tells AWS which subnets Redis can live in)
resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "redis-subnet-group"
  subnet_ids = [var.private_subnet_id]
}

# 3. The Actual Redis Cluster
resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "muchtodo-redis"
  engine               = "redis"
  node_type            = "cache.t3.micro" # Stay in Free Tier territory
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  port                 = 6379
  security_group_ids   = [aws_security_group.redis_sg.id]
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name
}