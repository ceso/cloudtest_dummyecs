variable "vpc_id" {
    description = "Id of the vpc where the resources will be cretaed"
}

variable "vpc_public_subnets" {
    description = "Id of the public subnets to be used"
}

variable "vpc_private_subnets" {
    description = "Id of the private subnets to be used"
}

variable "domain_site" {
    description = "Doomain name of the site"
    default = "dummypoc.link"
}

variable "alb_name" {
    description = "Name that will have the application load balancer"
    default = "alb-external"
}
    
variable "ecs_tg_name" {
    description = "Name of the target group used for the load balancer"
    default = "dmy-tg"
}

variable "alb_target_group_check_path" {
    description = "Path to be used for the halth check of the app"
    default = "/"
}

variable "ecs_cluster_name" {
    description = "Name that the ECS cluster will have"
    default = "dummy-ecs"
}

variable "ec2_ami_id" {
    description = "AMI ID to be used for the EC2 instances"
    default = "ami-0cff7528ff583bf9a"
}

variable "ec2_instance_type" {
    description = "Type of EC2 instances to be used (e.g: t2.micro)"
    default = "t2.micro"
}

variable "ec2_spot_price" {
    description = "Spot price for EC2 instances, basically how much one wants to pay for them"
    default = "0.0035"
}
    
variable "ecs_service_name" {
    description = "Name of the ECS Service"
    default = "worker"
}

variable "ecs_srv_desired_count" {
    description = "Desired count to have for the ECS service"
    default = 2
}

variable "ecs_container_name" {
    description = "Name of the containers to be used by ECS"
    default = "nginx-hello"
}

variable "ecs_container_port" {
    description = "Port where the containers used for ECS will listen to"
    default = "8080"
}

variable "ecs_task_family" {
    description = "Family to be used with ECS task"
    default = "worker"
}
    
variable "ecs_task_memory" {
    description = "Amount of memory the ECS task will have"
    default = 248
}

variable "prefix" {
    description = "Prefix that the resources will have in it's name"
}

variable "ecs_task_docker_image_repo" {
    description = "URL of the image of the container to be used in task definitions"
}

variable "tags" {
    default = {
        managed_by = "terraform"
        goal = "challenge_test"
    }
}

variable "route53_zone_id" {
    description = "ID of the zone where a record will be created"
}

variable "validate_tls_cert" {
    description = "Specifies if the certificate created by ACM will be validated"
    default = false
}

variable "wait_for_validation_tls_cert" {
    description = "Specifies if terraform will wait until the validation of the crt finished before continues"
    default = false
}

variable "desired_asg_count" {
    description = "The number of Amazon EC2 instances that should be running in the group"
    default = 2
}

variable "min_asg_count" {
    description = "The minimum size of the Auto Scaling Group"
    default = 1
}

variable "max_asg_count" {
    description = "The maximum size of the Auto Scaling Group"
    default = 10
}