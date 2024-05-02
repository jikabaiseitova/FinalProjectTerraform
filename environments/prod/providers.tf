terraform {
  required_providers {
    aws         = {
      source    = "hashicorp/aws"
      version   = ">= 5.46.0"
    }
    cloudflare  = {
      source    = "cloudflare/cloudflare"
      version   = "~> 2.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "cloudflare" {}