resource "aws_security_group" "ecs_sg" {
    vpc_id      = var.vpc_id

    ingress {
        from_port       = 443
        to_port         = 443
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    egress {
        from_port       = 0
        to_port         = 65535
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    tags = var.tags
}

resource "aws_security_group" "app_sg" {
    vpc_id      = var.vpc_id

    ingress {
        protocol        = "tcp"
        from_port       = 8080
        to_port         = 8080
        cidr_blocks     = ["0.0.0.0/0"]
        security_groups = [aws_security_group.ecs_sg.id]
    }

    ingress {
        from_port       = 443
        to_port         = 443
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    ingress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    egress {
        from_port       = 0
        to_port         = 65535
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    tags = var.tags
}