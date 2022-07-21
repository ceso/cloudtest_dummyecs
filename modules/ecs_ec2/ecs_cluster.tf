resource "aws_ecs_cluster" "ecs_cluster" {
    name  = var.ecs_cluster_name
    tags = var.tags
}

resource "aws_launch_configuration" "ecs_launch_config" {
    image_id             = var.ec2_ami_id
    iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
    security_groups      = [aws_security_group.ecs_sg.id]
    user_data = <<EOF
#!/bin/bash
function check_srv(){
srv=$1
if [ ! $(systemctl status $srv | grep -q running) ]; then
  systemctl start $srv
fi
}
yum upgrade -y
amazon-linux-extras install ecs
check_srv amazon-ssm-agent
echo ECS_CLUSTER=${var.ecs_cluster_name} >> /etc/ecs/ecs.config
for i in stop start; do service docker $i; done
docker pull amazon/amazon-ecs-agent:latest
systemctl daemon-reload
systemctl enable ecs
systemctl start --no-block ecs
EOF
    instance_type        = var.ec2_instance_type
    name = var.ecs_cluster_name
    associate_public_ip_address = false
    spot_price = var.ec2_spot_price
}

resource "aws_autoscaling_group" "failure_analysis_ecs_asg" {
    name                      = "${var.prefix}-asg"
    vpc_zone_identifier       = var.vpc_private_subnets
    launch_configuration      = aws_launch_configuration.ecs_launch_config.name
    desired_capacity          = var.desired_asg_count
    min_size                  = var.min_asg_count
    max_size                  = var.max_asg_count
    health_check_grace_period = 300
    health_check_type         = "EC2"
    default_cooldown          = 30

    tag {
        key   = "Name"
        value = var.ecs_cluster_name
        propagate_at_launch = true
    }
    
}