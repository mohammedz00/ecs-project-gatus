local_vpc_cidr      = "10.0.0.0/16"
public_subnet_cidr  = ["10.0.0.0/24", "10.0.2.0/24"]
private_subnet_cidr = ["10.0.1.0/24", "10.0.3.0/24"]
availability_zones  = ["eu-west-1a", "eu-west-1b"]
project_name        = "gatus"

task_definition_family   = "gatus-task-definition"
policy_arn               = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
requires_compatibilities = "FARGATE"
network_mode             = "awsvpc"
ecs_cpu                  = 512
ecs_memory               = 1024
container_port           = 8080
host_port                = 8080
ecr_image                = "145523122776.dkr.ecr.eu-west-1.amazonaws.com/zenudeen-gatus-ecr:latest"
desired_count            = 2

domain_name = "zenudeens.com"

oidc-policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"


