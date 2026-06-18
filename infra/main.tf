# VPC
module "vpc" {
  source              = "./modules/vpc"
  local_vpc_cidr      = var.local_vpc_cidr
  availability_zones  = var.availability_zones
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  project_name        = var.project_name
}

# SG
module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id

}

# ALB
module "alb" {
  source              = "./modules/alb"
  vpc_id              = module.vpc.vpc_id
  public_subnet_a_id  = module.vpc.public_subnet_ids[0]
  public_subnet_b_id  = module.vpc.public_subnet_ids[1]
  load-balancer-sg-id = module.sg.lb-sg-id
  acm_app_cert_arn    = module.acm.acm_app_cert_arn
  app_cert_validation = module.acm.app_cert_validation
}

# ECS
module "ecs" {
  source                   = "./modules/ecs"
  task_definition_family   = var.task_definition_family
  policy_arn               = var.policy_arn
  requires_compatibilities = var.requires_compatibilities
  network_mode             = var.network_mode
  ecs_cpu                  = var.ecs_cpu
  ecs_memory               = var.ecs_memory
  container_port           = var.container_port
  host_port                = var.host_port
  ecr_image                = var.ecr_image
  private_subnet_a_id      = module.vpc.private_subnet_ids[0]
  private_subnet_b_id      = module.vpc.private_subnet_ids[1]
  container_sg_id          = module.sg.container-sg-id
  alb_target_group_arn     = module.alb.lb_target_group_arn
  desired_count            = var.desired_count
  project_name             = var.project_name
}


# Route 53
module "route53" {
  source      = "./modules/route53"
  domain_name = var.domain_name
  lb_zone_id  = module.alb.lb_zone_id
  lb_dns_name = module.alb.lb_dns_name
}


# ACM
module "acm" {
  source          = "./modules/acm"
  domain_name     = var.domain_name
  route53_zone_id = module.route53.route53_zone_id
}
