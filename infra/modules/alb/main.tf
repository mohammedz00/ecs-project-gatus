# Load balancer

resource "aws_lb" "gatus-lb" {
  name               = "gatus-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.load-balancer-sg-id]
  subnets            = [var.public_subnet_a_id, var.public_subnet_b_id]

  tags = {
    Name = "gatus-lb"
  }

}

resource "aws_lb_target_group" "gatus-lb-tg" {
  name        = "gatus-lb-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path = "/"
    port = "8080"
  }

}

resource "aws_lb_listener" "gatus-lb-listener-https" {
  load_balancer_arn = aws_lb.gatus-lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_app_cert_arn
  depends_on        = [var.app_cert_validation]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gatus-lb-tg.arn
  }
}

resource "aws_lb_listener" "https-redirect" {
    load_balancer_arn = aws_lb.gatus-lb.arn
    port = "80"
    protocol = "HTTP"

    default_action {
      type = "redirect"

      redirect {
        port = "443"
        protocol = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  
}

# Original HTTP listener

# resource "aws_lb_listener" "gatus-lb-listener" {
#   load_balancer_arn = aws_lb.gatus-lb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.gatus-lb-tg.arn
#   }
# }