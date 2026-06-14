variable "domain_name" {
  type        = string
  description = "The domain name"

}

variable "route53_cname" {
  type        = any
  description = "The route53 CNAME record"

}