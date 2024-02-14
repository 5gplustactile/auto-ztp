terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">=5.23.0"
    }
  }
}

provider "aws" {
  region = "eu-west-3"
  profile = "uma"
  default_tags {
    tags = {
      subject = "terraform to deploy vpc-digital-twins cluster"
      environment = "Outpost"
      owner = ""
      project = ""
    }
  }
  
}