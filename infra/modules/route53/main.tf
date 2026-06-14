# Route 53
resource "aws_route53_zone" "app" {
    name = var.domain_name

    tags = {
      Environment = "dev"
    }
  
}

resource "aws_route53_record" "app-a-record" {
    zone_id = aws_route53_zone.app.id
    name = var.domain_name
    type = "A"
    
    alias {
      zone_id = var.lb_zone_id
      name = var.lb_dns_name
      evaluate_target_health = true
    }
  
}

# resource "aws_route53_record" "cname" {
#   for_each = {
#     for dvo in aws_acm_certificate.app-certificate.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }

#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   ttl             = 60
#   type            = each.value.type
#   zone_id         = aws_route53_zone.app.zone_id
# }