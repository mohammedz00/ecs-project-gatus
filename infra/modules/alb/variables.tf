variable "vpc_id" {
  type        = string
  description = "The VPC ID"

}

variable "load-balancer-sg-id" {
  type        = string
  description = "The ID of the load balancer sg"

}


variable "public_subnet_a_id" {
  type        = string
  description = "Public subnet a ID"

}

variable "public_subnet_b_id" {
  type        = string
  description = "Public subnet b ID"

}

variable "acm_app_cert_arn" {
  type        = any
  description = "The ACM app certificate ARN"

}

variable "app_cert_validation" {
  type        = any
  description = "ACM app cert validation"

}
