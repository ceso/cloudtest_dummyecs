variable "prefix" {
    default = "dummy"
}

variable "tags" {
    default = {
        managed_by = "terraform"
        goal = "challenge_test"
    }
}

module "container-image" {
  source  = "eliotlim/container-image/aws"
  version = "0.0.8"
  # insert the 4 required variables here
  build_context = "."
  build_dockerfile = "./Dockerfile"
  name = "dummypoc"
  #create = false
  tags = var.tags
}

module "vpc" {
    source = "terraform-aws-modules/vpc/aws"

    name = "${var.prefix}-vpc"
    cidr = "10.0.0.0/16"

    azs = data.aws_availability_zones.this.names
    private_subnets         = ["10.0.1.0/24", "10.0.2.0/24"]
    public_subnets          = ["10.0.101.0/24", "10.0.102.0/24"]
    tags = var.tags
    enable_nat_gateway      = true
    single_nat_gateway      = false
    one_nat_gateway_per_az  = false
    enable_dns_hostnames    = true
}

module "ecs_ec2" {
    source = "./modules/ecs_ec2"

    vpc_id = module.vpc.vpc_id
    vpc_public_subnets = module.vpc.public_subnets
    vpc_private_subnets = module.vpc.private_subnets
    prefix = "dummy"
    domain_site = "CHANGEME" 
    alb_name = "alb-external"
    ecs_tg_name = "dmy-tg"
    alb_target_group_check_path = "/"
    ecs_cluster_name = "dummy-ecs"
    ec2_ami_id = "ami-0cff7528ff583bf9a"
    ec2_instance_type = "t2.micro"
    ec2_spot_price = "0.0035"
    ecs_service_name = "worker"
    ecs_srv_desired_count = 2
    ecs_container_name = "dummypoc"
    ecs_container_port = 8080
    ecs_task_family = "worker"
    ecs_task_memory = 248
    ecs_task_docker_image_repo = module.container-image.repository_url 
    route53_zone_id = "CHANGEME"
    depends_on = [module.container-image, module.vpc]
    validate_tls_cert = true
    wait_for_validation_tls_cert = true
}