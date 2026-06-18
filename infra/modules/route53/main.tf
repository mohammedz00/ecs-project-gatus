# Route 53
resource "aws_route53_zone" "app" {
  name = var.domain_name

  tags = {
    Environment = "dev"
  }

}

resource "aws_route53domains_registered_domain" "name-servers" {
  domain_name = "app.zenudeens.com"

  name_server {
    name = aws_route53_zone.app.name_servers[0]
  }
  name_server {
    name = aws_route53_zone.app.name_servers[1]
  }
  name_server {
    name = aws_route53_zone.app.name_servers[2]
  }
  name_server {
    name = aws_route53_zone.app.name_servers[3]
  }

}

resource "aws_route53_record" "app-a-record" {
  zone_id = aws_route53_zone.app.id
  name    = var.domain_name
  type    = "A"

  alias {
    zone_id                = var.lb_zone_id
    name                   = var.lb_dns_name
    evaluate_target_health = true
  }

}

