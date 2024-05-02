terraform {
  backend "s3" {
    bucket = "terraform.tfstate-jyldyz"
    key    = "finalautoscaling/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "finalnetworking" {
  backend = "s3"
  config = {
    bucket  = "terraform.tfstate-jyldyz"
    key     = "finalnetworking/terraform.tfstate"
    region  = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ami" {
    most_recent     = true
    owners          = ["137112412989"]

    filter {
        name    = "name"
        values  = ["al2023-ami-2023.4.20240401.1-kernel-6.1-x86_64"]
    }
}

module "sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"

  name        = "user-service"
  description = "security group"
  vpc_id      = data.terraform_remote_state.finalnetworking.outputs.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp"]

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "ports"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    "Name" = var.instance_name
  }
}

module "autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "7.4.1"

  name                = "asg"
  vpc_zone_identifier = data.terraform_remote_state.finalnetworking.outputs.public_subnets

  max_size            = var.max_size
  min_size            = var.min_size
  desired_capacity    = var.desired_size

  image_id      = var.user_specified_ami != "" ? var.user_specified_ami : data.aws_ami.ami.id
  
  instance_type = var.instance_type
  security_groups = [module.sg.security_group_id]

  tags = {
    "Name" = var.instance_name
  }
}

