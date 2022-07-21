resource "aws_route53_record" "app" {
    #zone_id = aws_route53_zone.r53_private_zone.zone_id
    zone_id = var.route53_zone_id
    name    = ""
    type    = "A"
    alias {
        name = module.alb-external.lb_dns_name
        zone_id = module.alb-external.lb_zone_id
        evaluate_target_health = true
    }
}