variable "local_vpc_cidr" {
    type = string
  
  
}

variable "all_traffic_cidr" {
    type = string
  
  
}

variable "public_subnet_cidr" {
    type = list(string)
 
  
}

variable "private_subnet_cidr" {
    type = list(string)
   
  
}

variable "availability_zones" {
    type = list(string)
    
  
}

variable "domain_name" {
    type = string
  
}

variable "ecr_image" {
  type = string

}