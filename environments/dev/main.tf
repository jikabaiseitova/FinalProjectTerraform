locals {
  max_size          = 4
  min_size          = 2
  desired_capacity  = 3
  instance_type     = "t3.micro"
  name              = "Jyldyz-dev"
}

module "dev_networking" {
  source             = "terraform-aws-modules/vpc/aws"
  name               = "dev-vpc"
  cidr               = data.terraform_remote_state.finalnetworking.outputs.vpc_cidr_block
  azs                = data.terraform_remote_state.finalnetworking.outputs.azs
  private_subnets    = ["10.1.104.0/24", "10.1.105.0/24", "10.1.106.0/24"]
  public_subnets     = ["10.1.101.0/24", "10.1.102.0/24", "10.1.103.0/24"]
  enable_nat_gateway = true
  single_nat_gateway = true
}

module "sg_dev" {
  source             = "terraform-aws-modules/security-group/aws"
  version            = "5.1.2"
  name               = "user-service-dev"
  description        = "security group for dev environment"
  vpc_id             = module.dev_networking.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  tags = {
    "Name" = "${local.name}-sg-dev"
  }
}

module "autoscaling_dev" {
  source             = "terraform-aws-modules/autoscaling/aws"
  version            = "7.4.1"
  name               = "asg-dev"
  vpc_zone_identifier = module.dev_networking.private_subnets
  max_size           = local.max_size
  min_size           = local.min_size
  desired_capacity   = local.desired_capacity
  image_id           = data.aws_ami.ami.id
  instance_type      = local.instance_type
  security_groups    = [module.sg_dev.security_group_id]

  tags = {
    "Name" = "${local.name}-asg-dev"
  }
  
  user_data = filebase64("${path.module}/script.sh")
}

module "alb" {
  source             = "terraform-aws-modules/alb/aws"
  version            = "9.9.0"
  name_prefix        = "my"
  subnets            = module.dev_networking.private_subnets
  vpc_id             = module.dev_networking.vpc_id
  security_groups    = [module.sg_dev.security_group_id]
}