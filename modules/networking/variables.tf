variable "instance_name" {
  description = "name"
  default     = "JK"
}

variable "azs" {
  description = "azs"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "public_subnets" {
  description = "public subnets"
  type        = list(string)
  default     = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
}

variable "private_subnets" {
  description = "private subnets"
  type        = list(string)
  default     = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  default     = "10.1.0.0/16"
}