output "container-sg-id" {
    description = "The ID of the container SG"
    value = aws_security_group.container-sg.id
  
}

output "lb-sg-id" {
    description = "The ID of the load balancer SG"
    value = aws_security_group.load-balancer-sg.id
  
}