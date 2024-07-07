module "asg" {
  source     = "terraform-aws-modules/autoscaling/aws"
  depends_on = [module.s3_bucket, aws_s3_bucket_object.php]

  # Autoscaling group
  name = var.asg_name

  min_size            = 2
  max_size            = 4
  desired_capacity    = 2
  health_check_type   = "EC2"
  vpc_zone_identifier = module.vpc.private_subnets

  scaling_policies = {
    Ec2Scaling = {
      policy_type = "TargetTrackingScaling"
      target_tracking_configuration = {
        predefined_metric_specification = {
          predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = 60.0
      }
    }
  }

  # Launch template
  launch_template_name   = var.lt_name
  update_default_version = true
  security_groups        = [aws_security_group.ec2_sg.id]
  image_id               = var.ami
  instance_type          = var.instance_type
  user_data              = base64encode(file("backend.tftpl"))

  # IAM role & instance profile
  create_iam_instance_profile = true
  iam_role_name               = "IAM_ROLE"
  iam_role_path               = "/ec2/"
  iam_role_description        = "Harshil Khamar IAM Role"
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    S3Access                     = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  }

  tag_specifications = [
    {
      resource_type = "instance"
      tags          = local.ec2_tags
    }
  ]
  target_group_arns = [module.alb.target_group_arns[0]]
  tags              = local.asg_tags
}

resource "aws_security_group" "ec2_sg" {
  name   = var.ec2_sg_name
  vpc_id = module.vpc.vpc_id
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
  tags = local.ec2_sg_tags
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}