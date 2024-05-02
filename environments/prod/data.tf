terraform {
  backend "s3" {
    bucket = "terraform.tfstate-jyldyz"
    key    = "finalprod/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "finalautoscaling" {
  backend   = "s3"
  config    = {
    bucket  = "terraform.tfstate-jyldyz"
    key     = "finalautoscaling/terraform.tfstate"
    region  = "us-east-1"
  }
}

data "terraform_remote_state" "finalnetworking" {
  backend   = "s3"
  config    = {
    bucket  = "terraform.tfstate-jyldyz"
    key     = "finalnetworking/terraform.tfstate"
    region  = "us-east-1"
  }
}

data "aws_ami" "ami" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.4.20240401.1-kernel-6.1-x86_64"]
  }
}

