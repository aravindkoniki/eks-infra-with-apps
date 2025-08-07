# Route53 record for app1
resource "aws_route53_record" "app1" {
  provider = aws.MY_NETWORKING
  zone_id  = data.aws_route53_zone.main.zone_id
  name     = "app1.${local.domain_name}"
  type     = "A"

  alias {
    name                   = data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].hostname
    zone_id                = data.aws_lb.nlb.zone_id
    evaluate_target_health = false
  }
}

# Route53 record for app2
resource "aws_route53_record" "app2" {
  provider = aws.MY_NETWORKING
  zone_id  = data.aws_route53_zone.main.zone_id
  name     = "app2.${local.domain_name}"
  type     = "A"

  alias {
    name                   = data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].hostname
    zone_id                = data.aws_lb.nlb.zone_id
    evaluate_target_health = false
  }
}
