locals {
  ingresses = {
    22 = "10.1.0.0/16",
    80 = "0.0.0.0/0"
  }
}

resource "aws_s3_bucket" "static_website" {
  bucket          = "finalprojectterraform"

  force_destroy   = true  

  website {
    index_document = "index.html"  
    error_document = "error.html"  
  }
}

module "alb" {
  source              = "terraform-aws-modules/alb/aws"
  version             = "9.9.0"
  name_prefix         = "prod"
  subnets             = tolist(toset(data.terraform_remote_state.finalnetworking.outputs.private_subnets))
  vpc_id              = data.terraform_remote_state.finalnetworking.outputs.vpc_id
  security_groups     = [data.terraform_remote_state.finalautoscaling.outputs.security_group_id]
}

resource "aws_lb_listener" "alb_listener" {
  count               = length(var.lb_listener_ports)
  load_balancer_arn   = module.alb.arn
  port                = var.lb_listener_ports[count.index]
  protocol            = "HTTP"

  default_action {
    type              = "forward"
    target_group_arn  = aws_lb_target_group.tg[count.index].arn
  }
}


variable "lb_listener_ports" {
  type    = list(number)
  default =  [80, 443, 22] 
}

resource "aws_lb_target_group" "tg" {
  count       = length(var.lb_listener_ports)
  name_prefix = "tg"

  port        = var.lb_listener_ports[count.index]
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.finalnetworking.outputs.vpc_id
  target_type = "instance"
}

resource "aws_security_group" "sg" {
  vpc_id = data.terraform_remote_state.finalnetworking.outputs.vpc_id

  dynamic "ingress" {
    for_each = local.ingresses
    content {
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}