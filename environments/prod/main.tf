resource "aws_s3_bucket" "static_website" {
  bucket = "finalprojectterraform"

  # Отключение блокировки публичного доступа
  force_destroy = true  # Этот параметр разрешает удаление бакета даже если он не пустой

  website {
    index_document = "index.html"  
    error_document = "error.html"  
  }
}

module "alb" {
  source       = "terraform-aws-modules/alb/aws"
  version      = "9.9.0"
  name_prefix  = "my"
  subnets      = data.terraform_remote_state.finalnetworking.outputs.public_subnets
  vpc_id       = data.terraform_remote_state.finalnetworking.outputs.vpc_id
}