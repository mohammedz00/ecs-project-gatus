variable "task_definition_family" {
    type = string
    description = "Task definition family name"
  
}

variable "requires_compatibilities" {
    type = string
    description = "The compatability of the ECS service (FARGATE, EC2, External)"
  
}

variable "network_mode" {
    type = string
    description = "ECS task definition network mode (awsvpc)"
  
}

variable "policy_arn" {
    type = string
    description = "The IAM policy ARN"
  
}

variable "ecs_cpu" {
    type = number
    description = "The CPU of the ECS task definition"
  
}

variable "ecs_memory" {
    type = number
    description = "The memory of the ECS task definition"
  
}

variable "ecr_image" {
    type = string
    description = "The ECR image"
  
}

variable "container_port" {
    type = number
    description = "The container port"
  
}

variable "host_port" {
    type = number
    description = "The host port"
  
}

variable "private_subnet_a_id" {
    type = string
    description = "The private subnet a ID"
  
}

variable "private_subnet_b_id" {
    type = string
    description = "The private subnet b ID"
  
}

variable "container_sg_id" {
    type = string
    description = "The container sg IG"
  
}

variable "alb_target_group_arn" {
    type = string
    description = "The ALB target group ARN"
  
}

variable "desired_count" {
    type = number
    description = "The number of tasks to run"
  
}

variable "project_name" {
    type = string
    description = "The project name"
  
}