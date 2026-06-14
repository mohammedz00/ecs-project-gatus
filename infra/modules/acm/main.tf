# ACM
resource "aws_acm_certificate" "app-certificate" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_acm_certificate_validation" "app-cert-validation" {
  certificate_arn         = aws_acm_certificate.app-certificate.arn
  validation_record_fqdns = [for record in var.route53_cname : record.fqdn]
}