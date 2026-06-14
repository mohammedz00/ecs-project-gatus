# ECS

# ECS Cluster
resource "aws_ecs_cluster" "gatus-ecs-cluster" {
  name = "${var.project_name}-ecs-cluster"

  setting {
    name  = "containerInsights"
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
        Action = "sts:AssumeRole"
        Effect = "Allow"
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
  role       = aws_iam_role.ecs-task-execution-role.name
  policy_arn = var.policy_arn
  # The permissions that this role can use
}

# ECS Task Definition
resource "aws_ecs_task_definition" "gatus-task-definition" {
  family                   = var.task_definition_family               # Tasl definition name
  requires_compatibilities = [var.requires_compatibilities]           # Uses fargate only
  network_mode             = var.network_mode                         # What network method to use
  cpu                      = var.ecs_cpu                              # 512 CPU refers to 0.5 CPU
  memory                   = var.ecs_memory                           # 1024 refers to 1GB memory
  execution_role_arn       = aws_iam_role.ecs-task-execution-role.arn # Uses the ECS task execution role for this task

  container_definitions = jsonencode([{
    name : "${var.project_name}-container" # container name
    image : var.ecr_image                  # image pulled from ECR
    essential : true                       # Requirement to have this image
    portMappings : [
      {
        containerPort = var.container_port
        hostPort      = var.host_port
        # Application uses port 8080 so these are assigned accordingly

      }
    ]

    }
    ]
  )
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
    # specifying runtime requirements
  }


}


# # ECS service
resource "aws_ecs_service" "gatus-service" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.gatus-ecs-cluster.id
  task_definition = aws_ecs_task_definition.gatus-task-definition.arn
  desired_count   = var.desired_count
  launch_type     = var.requires_compatibilities



  network_configuration {
    subnets          = [var.private_subnet_a_id, var.private_subnet_b_id]
    security_groups  = [var.container_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_port   = var.container_port
    container_name   = "${var.project_name}-container"
  }

}
