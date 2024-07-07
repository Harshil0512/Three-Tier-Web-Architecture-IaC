locals {
  Name  = "harshil-khamar"
  Owner = "harshil.khamar@intuitive.cloud"
  vpc_tags = {
    Name  = "${local.Name}-VPC"
    Owner = local.Owner
  }
  public_subnet_tags = {
    Name  = "${local.Name}-Public-Subnet"
    Owner = local.Owner
  }
  private_subnet_tags = {
    Name  = "${local.Name}-Private-Subnet"
    Owner = local.Owner
  }
  database_subnet_tags = {
    Name  = "${local.Name}-Database-Subnet"
    Owner = local.Owner
  }
  igw_tags = {
    Name  = "${local.Name}-IGW"
    Owner = local.Owner
  }
  nat_gateway_tags = {
    Name  = "${local.Name}-NAT"
    Owner = local.Owner
  }
  public_route_table_tags = {
    Name  = "${local.Name}-Public-Rt"
    Owner = local.Owner
  }
  private_route_table_tags = {
    Name  = "${local.Name}-Private-Rt"
    Owner = local.Owner
  }
  database_route_table_tags = {
    Name  = "${local.Name}-Database-Rt"
    Owner = local.Owner
  }
  rds_tags = {
    Name  = "${local.Name}-Rds"
    Owner = local.Owner
  }
  rds_sg_tags = {
    Name  = "${local.Name}-Rds-Sg"
    Owner = local.Owner
  }
  ec2_tags = {
    Name  = "${local.Name}-EC2"
    Owner = local.Owner
  }
  asg_tags = {
    Name  = "${local.Name}-ASG"
    Owner = local.Owner
  }
  ec2_sg_tags = {
    ame   = "${local.Name}-Ec2-Sg"
    Owner = local.Owner
  }
  alb_tags = {
    ame   = "${local.Name}-Alb"
    Owner = local.Owner
  }
  alb_sg_tags = {
    ame   = "${local.Name}-Alb-Sg"
    Owner = local.Owner
  }
}