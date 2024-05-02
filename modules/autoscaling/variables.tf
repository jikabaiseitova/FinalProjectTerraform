variable "instance_name" {
    description = "Instance name"
    default     = "JK"
}

variable "instance_type" {
  description = "instance type"
  default     = "t3.micro"
}

variable "desired_size" {
  description = "desired size"
  default     = 1
}

variable "max_size" {
  description = "max size"
  default     = 3
}

variable "min_size" {
  description = "min size"
  default     = 1
}

variable "user_specified_ami" {
  description = "User-specified AMI for launch template"
  default     = ""
}
