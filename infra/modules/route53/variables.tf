variable "domain_name" {
  type        = string
  description = "The domain name"

}

variable "lb_zone_id" {
  type        = string
  description = "The ALB zone ID"

}

variable "lb_dns_name" {
  type        = string
  description = "The ALB DNS name"

}

variable "acm_domain_validation_option" {
  type        = any
  description = "The ACM domain validation option"

}