# ALB , public facing load balancer
resource "aws_lb" "app_alb" {
  name = "${var.project_name}-alb"

  internal = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb_sg.id
  ]

  subnets = [
    for s in aws_subnet.public : s.id
  ]

  tags = {
    Name = "${var.project_name}-alb"
  }
}



# Target group for the app ,  (HTTP on 80)
resource "aws_lb_target_group" "app_tg" {
  name = "${var.project_name}-tg"

  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.main.id

  # simple health check
  health_check {
    path = "/"
    matcher = "200"
    interval = 30
    timeout  = 5
    healthy_threshold = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "${var.project_name}-tg"
  }
}



# Listener , takes HTTP ,  forwards to TG
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn

  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}



# Attaching tha EC2 instance to the TG
resource "aws_lb_target_group_attachment" "app_attachment" {
  target_group_arn = aws_lb_target_group.app_tg.arn

  target_id = aws_instance.app.id
  port      = 80
}
