# Security groups

# Load balancer security group
resource "aws_security_group" "load-balancer-sg" {
  name = "load-balancer-sg"
  vpc_id = var.vpc_id

  # Allow HTTP traffic from anywhere
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  # Allow HTTPS traffic from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all traffic out of ALB
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "load-balancer-sg"
  }
}

# Container security group (allows traffic only from the ALB)
resource "aws_security_group" "container-sg" {
    name = "container-sg"
    vpc_id = var.vpc_id

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        security_groups = [aws_security_group.load-balancer-sg.id]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "container-sg"
    }
  
}