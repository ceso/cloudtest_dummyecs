resource "aws_ecs_service" "worker" {
    name            = var.ecs_service_name
    cluster         = aws_ecs_cluster.ecs_cluster.id
    task_definition = aws_ecs_task_definition.task_definition.arn
    desired_count   = var.ecs_srv_desired_count

    load_balancer {
        container_name = var.ecs_container_name
        container_port = var.ecs_container_port
        target_group_arn = module.alb-external.target_group_arns[0]
    }
    network_configuration {
      security_groups = [aws_security_group.app_sg.id]
      subnets = var.vpc_private_subnets
      assign_public_ip = false
    }

    tags = var.tags

    depends_on = [module.alb-external.lb_listener]
}