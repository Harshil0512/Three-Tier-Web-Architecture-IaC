data "aws_route53_zone" "private" {
  name         = "dns-poc-onprem.tk"
  private_zone = true
}

data "aws_route53_zone" "public" {
  name         = "dns-poc-onprem.tk"
  private_zone = false
}

resource "aws_route53_zone_association" "private" {
  zone_id = data.aws_route53_zone.private.id
  vpc_id  = module.vpc.vpc_id
}

resource "aws_route53_record" "rds" {
  zone_id = data.aws_route53_zone.private.id
  name    = "harshilkhamarrds"
  type    = "CNAME"
  ttl     = 300
  records = [module.rds.db_instance_address]
}

resource "aws_route53_record" "cdn" {
  zone_id = data.aws_route53_zone.public.id
  name    = "harshilkhamarwebsite"
  type    = "CNAME"
  ttl     = 300
  records = [module.cdn.cloudfront_distribution_domain_name]
}

resource "aws_route53_record" "backend" {
  zone_id = data.aws_route53_zone.public.id
  name    = "harshilkhamarbackend"
  type    = "CNAME"
  ttl     = 300
  records = [module.alb.lb_dns_name]
}


