variable "local_vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
  
}

variable "all_traffic_cidr" {
    type = string
    default = "0.0.0.0/0"
  
}

variable "public_subnet_cidr" {
    type = list(string)
    default = [ "10.0.0.0/24", "10.0.2.0/24" ]
  
}

variable "private_subnet_cidr" {
    type = list(string)
    default = [ "10.0.1.0/24", "10.0.3.0/24" ]
  
}

variable "availability_zones" {
    type = list(string)
    default = [ "eu-west-1a", "eu-west-1b" ]
  
}