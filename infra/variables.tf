# VPC

variable "local_vpc_cidr" {
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

variable "project_name" {
  type        = string
  description = "The name of the project"

}


# ECS

variable "task_definition_family" {
  type        = string
  description = "Task definition family name"

}

variable "requires_compatibilities" {
  type        = string
  description = "The compatability of the ECS service (FARGATE, EC2, External)"

}

variable "network_mode" {
  type        = string
  description = "ECS task definition network mode (awsvpc)"

}

variable "policy_arn" {
  type        = string
  description = "The IAM policy ARN"

}

variable "ecs_cpu" {
  type        = number
  description = "The CPU of the ECS task definition"

}

variable "ecs_memory" {
  type        = number
  description = "The memory of the ECS task definition"

}

variable "ecr_image" {
  type        = string
  description = "The ECR image"

}

variable "container_port" {
  type        = number
  description = "The container port"

}

variable "host_port" {
  type        = number
  description = "The host port"

}

variable "desired_count" {
  type        = number
  description = "The number of tasks to run"

}


# Route 53

variable "domain_name" {
  type        = string
  description = "The domain name"

}

# IAM

variable "oidc-policy_arn" {
    type = string
    description = "The OIDC policy ARN"
  
}