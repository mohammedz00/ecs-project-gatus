variable "domain_name" {
  type        = string
  description = "The domain name"

}

# variable "route53_cname" {
#   type        = any
#   description = "The route53 CNAME record"

# }

variable "route53_zone_id" {
    type = string
    description = "Route53 hosted zone id"
  
}