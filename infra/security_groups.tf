# ALB SG 
resource "aws_security_group" "alb_sg" {
  name = "${var.project_name}-alb-sg"
  vpc_id = aws_vpc.main.id
  description = "Allow HTTP from internet"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]   # public
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]   # everything out
  }

  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}



# App SG — only ALB can hit it
resource "aws_security_group" "app_sg" {
  name = "${var.project_name}-app-sg"
  vpc_id = aws_vpc.main.id
  description = "Allow HTTP from ALB only"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    security_groups = [
      aws_security_group.alb_sg.id   # ALB SG → app SG
    ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-app-sg"
  }
}



# RDS SG — only app is allowed to touch Postgres
resource "aws_security_group" "rds_sg" {
  name = "${var.project_name}-rds-sg"
  vpc_id = aws_vpc.main.id
  description = "Allow Postgres from app SG"

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    security_groups = [
      aws_security_group.app_sg.id   # app → db
    ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-rds-sg"
  }
}
