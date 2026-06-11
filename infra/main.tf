
# VPC
resource "aws_vpc" "gatus-vpc" {

    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
      Name = "gatus-vpc"
    }
  
}

# Subnets
resource "aws_subnet" "public_subnet_a" {

    vpc_id = aws_vpc.gatus-vpc.id
    cidr_block = "10.0.0.0/24"
    map_public_ip_on_launch = true
    availability_zone = "eu-west-1a"

    tags = {
      Name = "PublicSubnetA"
    }
  
}

resource "aws_subnet" "private_subnet_a" {

    vpc_id = aws_vpc.gatus-vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "eu-west-1a"

    tags = {
      Name = "PrivateSubnetA"
    }
  
}

resource "aws_subnet" "public_subnet_b" {

    vpc_id = aws_vpc.gatus-vpc.id
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = true
    availability_zone = "eu-west-1b"

    tags = {
      Name = "PublicSubnetB"
    }
  
}

resource "aws_subnet" "private_subnet_b" {

    vpc_id = aws_vpc.gatus-vpc.id
    cidr_block = "10.0.3.0/24"
    availability_zone = "eu-west-1b"

    tags = {
      Name = "PrivateSubnetB"
    }
  
}