resource "aws_ecs_task_definition" "task_definition" {
    family                = var.ecs_task_family
    container_definitions = jsonencode(
        [
            {
                command     = []
                cpu         = 0
                entryPoint  = []
                environment = []
                essential   = true
                #image       = "${aws_ecr_repository.worker.repository_url}:dummy"
                image    = var.ecs_task_docker_image_repo
                name        = var.ecs_container_name
                portMappings = [
                    {
                        containerPort = var.ecs_container_port
                        hostPort      = var.ecs_container_port
                        protocol      = "tcp"
                    },
                ]
            }
        ]
    )
    network_mode       = "awsvpc"
    memory = var.ecs_task_memory
    tags = var.tags
}