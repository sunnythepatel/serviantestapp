
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}


provider "aws" {
  region  = "ap-southeast-2"
}

terraform {
  backend "s3" {
    bucket = "serviantestbucket"
    key    = "webappstate/terraform.tfstate"
    region = "ap-southeast-2"
  }
}