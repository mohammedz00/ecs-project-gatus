variable "local_vpc_cidr" {
    description = "The cidr of the VPC"
    type = string
  
  
}

variable "public_subnet_cidr" {
    description = "List of public subnet cidr"
    type = list(string)
 
  
}

variable "private_subnet_cidr" {
    description = "List of private subnet cidr"
    type = list(string)
   
  
}

variable "availability_zones" {
    description = "List of availability zones"
    type = list(string)
    
  
}

variable "project_name" {
    type = string
    description = "The name of the project"
  
}