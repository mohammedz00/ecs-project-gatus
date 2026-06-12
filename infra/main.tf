
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

# Internet Gateway
resource "aws_internet_gateway" "gatus-igw" {
    vpc_id = aws_vpc.gatus-vpc.id

    tags = {
      Name = "gatus-igw" 
    }
  
}

# Elastic IP allocation
resource "aws_eip" "natgw-eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.gatus-igw]
}

# NAT Gateway
resource "aws_nat_gateway" "gatus-natgw" {
connectivity_type = "public"
  allocation_id = aws_eip.natgw-eip.id
  subnet_id = aws_subnet.public_subnet_a.id
  depends_on = [aws_internet_gateway.gatus-igw]

  tags = {
    Name = "gatus-natgw"
  }
}


# Route tables

# Public Route
resource "aws_route_table" "public_route" {
    vpc_id = aws_vpc.gatus-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gatus-igw.id
    }

    tags = {
      Name = "PublicRoute"
    }
  
}

# Private Route
resource "aws_route_table" "private_route" {
    vpc_id = aws_vpc.gatus-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.gatus-natgw.id
    }

    tags = {
      Name = "PrivateRoute"
    }
  
}

# Route table associations

# Public route associations
resource "aws_route_table_association" "public-route-association-a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "public-route-association-b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_route.id
}

# Private route associations
resource "aws_route_table_association" "private-route-association-a" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_route.id
}

resource "aws_route_table_association" "private-route-association-b" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.private_route.id
}


# Security groups

# Load balancer security group
resource "aws_security_group" "load-balancer-sg" {
  name = "load-balancer-sg"
  vpc_id = aws_vpc.gatus-vpc.id

  # Allow HTTP traffic from anywhere
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
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
    vpc_id = aws_vpc.gatus-vpc.id

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

# Load balancer

resource "aws_lb" "gatus-lb" {
    name = "gatus-lb"
    internal = false
    load_balancer_type = "application"
    security_groups = [ aws_security_group.load-balancer-sg.id ]
    subnets = [ aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id ]
    
    tags = {
      Name = "gatus-lb"
    }
  
}

resource "aws_lb_target_group" "gatus-lb-tg" {
    name = "gatus-lb-tg"
    port = 8080
    protocol = "HTTP"
    target_type = "ip"
    vpc_id = aws_vpc.gatus-vpc.id

    health_check {
      path = "/"
      port = "8080"
    }
  
}

resource "aws_lb_listener" "gatus-lb-listener" {
  load_balancer_arn = aws_lb.gatus-lb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.gatus-lb-tg.arn
  }


}


# ECS

# ECS Cluster
resource "aws_ecs_cluster" "gatus-ecs-cluster" {
    name = "gatus-ecs-cluster"

    setting {
      name = "containerInsights"
      value = "enabled"
      # Provide CloudWatch metrics and insights
    }
  
}

# ECS Task Execution Role

# Defining who can use the role
resource "aws_iam_role" "ecs-task-execution-role" {
    name = "ecs-task-execution-role"
assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
          # ECS task agent is the only one who can use this role
        }
      }
    ]
  }) 
}

# Defining which permissions/tasks can be done with this role
resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy" {
  role = aws_iam_role.ecs-task-execution-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  # The permissions that this role can use
}

# ECS Task Definition
resource "aws_ecs_task_definition" "gatus-task-definition" {
        family = "gatus-task-definition" # Tasl definition name
        requires_compatibilities = ["FARGATE"] # Uses fargate only
        network_mode = "awsvpc" # What network method to use
        cpu = 512 # 512 CPU refers to 0.5 CPU
        memory = 1024 # 1024 refers to 1GB memory
        execution_role_arn = aws_iam_role.ecs-task-execution-role.arn # Uses the ECS task execution role for this task

        container_definitions = jsonencode([{
                name : "gatus-container" # container name
                image : "145523122776.dkr.ecr.eu-west-1.amazonaws.com/zenudeen/gatus:latest" # image pulled from ECR
                essential : true # Requirement to have this image
                portMappings : [
                    {
                        containerPort = 8080 
                        hostPort = 8080
                        # Application uses port 8080 so these are assigned accordingly
                        
                    }
                ]
                     
            }
        ]
        )
        runtime_platform {
                operating_system_family = "LINUX" 
                cpu_architecture = "X86_64"
                # specifying runtime requirements
            }

  
}


# # ECS service
resource "aws_ecs_service" "gatus-service" {
    name = "gatus-service"
    cluster = aws_ecs_cluster.gatus-ecs-cluster.id
    task_definition = aws_ecs_task_definition.gatus-task-definition.arn
    desired_count = 2
    launch_type = "FARGATE"
    
    

    network_configuration {
      subnets = [aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_b.id]
      security_groups = [ aws_security_group.container-sg.id ]
      assign_public_ip = false
    }

    load_balancer {
      target_group_arn = aws_lb_target_group.gatus-lb-tg.arn
      container_port = 8080
      container_name = "gatus-container"
    }
  
}


# Route 53
resource "aws_route53_zone" "app" {
    name = "app.zenudeen.com"

    tags = {
      Environment = "dev"
    }
  
}

resource "aws_route53_record" "app-a-record" {
    zone_id = aws_route53_zone.app.id
    name = "app.zenudeen.com"
    type = "A"
    
    alias {
      zone_id = aws_lb.gatus-lb.zone_id
      name = aws_lb.gatus-lb.dns_name
      evaluate_target_health = true
    }
  
}

resource "aws_route53_record" "cname" {
  for_each = {
    for dvo in aws_acm_certificate.app-certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.app.zone_id
}

# ACM
resource "aws_acm_certificate" "app-certificate" {
    domain_name = "app.zenudeen.com"
    validation_method = "DNS"

    lifecycle {
    create_before_destroy = true
  }
  
}

resource "aws_acm_certificate_validation" "app-cert-validation" {
  certificate_arn = aws_acm_certificate.app-certificate.arn
  validation_record_fqdns = [ for record in aws_route53_record.cname : record.fqdn ]
}