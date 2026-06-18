# output "route53_cname" {
#   value       = aws_route53_record.cname
#   description = "The route53 CNAME record"

# }

output "route53_zone_id" {
  value       = aws_route53_zone.app.zone_id
  description = "Route53 hosted zone id"

}