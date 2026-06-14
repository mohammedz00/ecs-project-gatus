output "lb_target_group_arn" {
    description = "The ALB target group ARN"
    value = aws_lb_target_group.gatus-lb-tg.arn
  
}