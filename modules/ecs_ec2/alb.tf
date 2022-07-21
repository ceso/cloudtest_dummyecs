module "acm" {
    source  = "terraform-aws-modules/acm/aws"
    version = "~> 3.0"

    domain_name  = var.domain_site
    zone_id      = var.route53_zone_id

    subject_alternative_names = [
        "*.${var.domain_site}",
    ]
    validate_certificate = var.validate_tls_cert
    wait_for_validation = var.wait_for_validation_tls_cert
    tags = var.tags
}

module "alb-external" {
    source  = "terraform-aws-modules/alb/aws"
    #version = "latest"
    # insert the 4 required variables here
    name = var.alb_name
    load_balancer_type               = "application"
    vpc_id                           = var.vpc_id
    subnets                          = var.vpc_public_subnets
    enable_cross_zone_load_balancing = true
    security_groups = [aws_security_group.app_sg.id]
    target_groups = [
        {
            name_prefix          = var.ecs_tg_name
            backend_protocol     = "HTTP"
            backend_port         = 80
            target_type          = "ip"
            deregistration_delay = 60
            health_check = {
                "enabled"             = true
                "healthy_threshold"   = 2
                "interval"            = 30
                "matcher"             = "200"
                "path"                = var.alb_target_group_check_path
                "port"                = "traffic-port"
                "protocol"            = "HTTP"
                "timeout"             = 10
                "unhealthy_threshold" = 5
            }
        }
    ]

    https_listeners = [
        {
        port               = 443
        protocol           = "HTTPS"
        certificate_arn    = module.acm.acm_certificate_arn
        action_type        = "forward"
        target_group_index = 0
        }
    ]
    http_tcp_listeners = [
        {
        port        = 80
        protocol    = "HTTP"
        action_type = "redirect"
        redirect = {
            port        = "443"
            protocol    = "HTTPS"
            status_code = "HTTP_301"
        }
        }
    ]    
    tags = var.tags

    depends_on = [
      module.acm.acm_certificate_status
    ]
}