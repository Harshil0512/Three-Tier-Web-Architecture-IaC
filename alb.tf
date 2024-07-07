module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"
  for_each = { for i,j in module.vpc:i=>j}
  name = var.alb_name

  load_balancer_type = "application"

  vpc_id          = each.value.vpc_id
  subnets         = each.value.public_subnets
  security_groups = [aws_security_group.alb_sg[i].id]

  target_groups = [
    {
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = var.certificate_arn
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

  tags = local.alb_tags
}

resource "aws_security_group" "alb_sg" {
  for_each={ for i,j in module.vpc:j.vpc_id=>j}
  name   = var.alb_sg_name
  vpc_id = each.key
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.alb_sg_tags

}

resource "aws_vpc_security_group_egress_rule" "alb_egress" {
  security_group_id = aws_security_group.alb_sg[count.index].id

  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
  referenced_security_group_id = aws_security_group.ec2_sg[count.index].id
  count=2
}
