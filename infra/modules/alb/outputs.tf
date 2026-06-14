output "lb_target_group_arn" {
  description = "The ALB target group ARN"
  value       = aws_lb_target_group.gatus-lb-tg.arn

}

output "lb_zone_id" {
  description = "The ALB zone ID"
  value       = aws_lb.gatus-lb.zone_id

}

output "lb_dns_name" {
  description = "The ALB DNS name"
  value       = aws_lb.gatus-lb.dns_name

}