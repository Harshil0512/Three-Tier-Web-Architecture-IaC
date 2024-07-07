module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs              = var.azs
  private_subnets  = var.private_subnets
  public_subnets   = var.public_subnets
  database_subnets = var.database_subnets

  enable_nat_gateway        = true
  enable_vpn_gateway        = false
  single_nat_gateway        = true
  public_subnet_tags        = local.public_subnet_tags
  private_subnet_tags       = local.private_subnet_tags
  database_subnet_tags      = local.database_subnet_tags
  igw_tags                  = local.igw_tags
  nat_gateway_tags          = local.nat_gateway_tags
  public_route_table_tags   = local.public_route_table_tags
  private_route_table_tags  = local.private_route_table_tags
  database_route_table_tags = local.database_route_table_tags

  tags = local.vpc_tags
}