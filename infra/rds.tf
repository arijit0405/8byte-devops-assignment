# Subnet group for RDS 
resource "aws_db_subnet_group" "postgres_subnet_group" {
  name = "${var.project_name}-rds-subnet-group"

  subnet_ids = [
    for s in aws_subnet.private : s.id
  ]

  tags = {
    Name = "${var.project_name}-rds-subnet-group"
  }
}


# Postgres instance, simple single-AZ setup
resource "aws_db_instance" "postgres" {
  identifier = "${var.project_name}-postgres"

  engine = "postgres"
  instance_class = "db.t3.micro"

  allocated_storage = var.db_allocated_storage
  username = var.db_username
  password = var.db_password

  db_subnet_group_name = aws_db_subnet_group.postgres_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  publicly_accessible = false   # db stays private
  skip_final_snapshot = true    # okay for assignment
  deletion_protection = false
  multi_az = false              # single-AZ is cheaper

  tags = {
    Name = "${var.project_name}-postgres"
  }
}
