vpc_name         = "<Project_Name>-vpc"
vpc_cidr         = "40.1.0.0/16"
azs              = ["us-east-1a", "us-east-1b", "us-east-1c","us-west-1a","us-west-1b","us-west-1c"]
private_subnets  = ["40.1.1.0/24", "40.1.2.0/24", "40.1.3.0/24","50.1.1.0/24", "50.1.2.0/24", "50.1.3.0/24",]
public_subnets   = ["40.1.101.0/24", "40.1.102.0/24", "40.1.103.0/24","50.1.101.0/24", "50.1.102.0/24", "50.1.103.0/24"]
database_subnets = ["40.1.104.0/24", "40.1.105.0/24", "40.1.106.0/24","50.1.104.0/24", "50.1.105.0/24", "50.1.106.0/24"]

identifier     = "<Your_DB_Identifier>"
db_name        = "<DB_NAME>"
instance_class = "db.t2.micro"
username       = "<DB_User_Name>"
password       = "<DB_Password>"
port           = "<DB_Port>"
rds_sg_name    = "<Project_Name>-rds-sg"

asg_name      = "<Project_Name>-asg-sg"
lt_name       = "<Project_Name>-asg-lt"
ami           = "ami-09538990a0c4fe9be"
instance_type = "t2.micro"
ec2_sg_name   = "<Project_Name>-ec2-sg"

alb_name        = "<Project_Name>-alb"
alb_sg_name     = "<Project_Name>-alb-sg"
certificate_arn = "<AWS_ACM_Certificate_ARN>"

s3_bucket_name = "<Project_Name>-test-bucket"

