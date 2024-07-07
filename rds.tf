module "rds" {
  source = "terraform-aws-modules/rds/aws"

  identifier = var.identifier

  engine                      = "mysql"
  engine_version              = "5.7"
  instance_class              = var.instance_class
  allocated_storage           = 5
  manage_master_user_password = false

  db_name  = var.db_name
  username = var.username
  password = var.password
  port     = var.port

  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  tags = local.rds_tags

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = module.vpc.database_subnets
  multi_az               = true
  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = "5.7"

  # Database Deletion Protection
  deletion_protection       = false
  storage_encrypted         = false
  create_db_option_group    = false
  create_db_parameter_group = false
  create_monitoring_role    = false
  skip_final_snapshot       = true
}

resource "aws_security_group" "rds_sg" {
  name   = var.rds_sg_name
  vpc_id = module.vpc.vpc_id
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }
  tags = local.rds_sg_tags
}