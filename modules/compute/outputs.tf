output "instance_public_ip" {
  value = aws_instance.web.public_ip
}

output "backend_sg_id" {
  value = aws_security_group.backend_sg.id
}

output "alb_dns_name" {
  value = aws_lb.backend_alb.dns_name
}