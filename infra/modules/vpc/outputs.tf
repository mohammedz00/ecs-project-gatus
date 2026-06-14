output "vpc_id" {
    description = "The ID of the VPC"
    value = aws_vpc.gatus-vpc.id
  
}

output "public_subnet_ids" {
    description = "The IDs of the public subnets"
    value = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]
  
}


output "private_subnet_ids" {
    description = "The IDs of the private subnets"
    value = [aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_b.id]
  
}

