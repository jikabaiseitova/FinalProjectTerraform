terraform {
  backend "s3" {
    bucket = "terraform.tfstate-jyldyz"
    key    = "finalnetworking/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.0"

  name               = "vpc"
  cidr               = var.vpc_cidr_block
  azs                = var.azs
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    "Name" = var.instance_name
  }
}