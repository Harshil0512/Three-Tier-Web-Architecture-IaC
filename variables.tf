variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "database_subnets" {
  type = list(string)
}

###################################### RDS ########################################

variable "identifier" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "db_name" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}

variable "port" {
  type = string
}

variable "rds_sg_name" {
  type = string
}


########################### ASG ####################################

variable "asg_name" {
  type = string
}

variable "lt_name" {
  type = string
}

variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ec2_sg_name" {
  type = string
}

variable "alb_name" {
  type = string
}

variable "alb_sg_name" {
  type = string
}


variable "certificate_arn" {
  type = string
}

############################### S3 ##############################

variable "s3_bucket_name" {
  type = string
}