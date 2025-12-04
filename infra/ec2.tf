#  latest 
data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name  = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"]   # official Amazon owner ID
}


# simple nginx just to return 200 on port 80
resource "aws_instance" "app" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  subnet_id                   = aws_subnet.public[0].id
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  associate_public_ip_address = true

  key_name = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install nginx1 -y
              systemctl enable nginx
              echo "<h1>8byte DevOps Assignment - App Server</h1>" > /usr/share/nginx/html/index.html
              systemctl start nginx
              EOF

  tags = {
    Name = "${var.project_name}-app-instance"
  }
}
