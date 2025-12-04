# VPC ID
output "vpc_id" {
  description = "main VPC ID"
  value = aws_vpc.main.id
}

# all public subnet IDs
output "public_subnet_ids" {
  description = "public subnet list"
  value = [
    for s in aws_subnet.public : s.id
  ]
}

# all private subnet IDs
output "private_subnet_ids" {
  description = "private subnet list"
  value = [
    for s in aws_subnet.private : s.id
  ]
}

# EC2 public IP (handy for quick tests)
output "app_instance_public_ip" {
  description = "public IP of app instance"
  value = aws_instance.app.public_ip
}

# ALB DNS — main entrypoint
output "alb_dns_name" {
  description = "ALB DNS name"
  value = aws_lb.app_alb.dns_name
}

# DB endpoint 
output "rds_endpoint" {
  description = "postgres endpoint"
  value = aws_db_instance.postgres.address
  sensitive = true
}
