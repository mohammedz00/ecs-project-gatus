output "domain_validation_options" {
    description = "The ACM domain validation option"
    value = aws_acm_certificate.app-certificate.domain_validation_options
  
}

output "acm_app_cert_arn" {
    description = "The ACM app certificate ARN"
    value = aws_acm_certificate.app-certificate.arn
  
}

output "app_cert_validation" {
    value = aws_acm_certificate_validation.app-cert-validation
    description = "The ACM app cert validation"
  
}