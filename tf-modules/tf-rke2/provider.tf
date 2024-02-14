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
      subject = "terraform to deploy RKE2 cluster in AWS Outpost"
      environment = "Outpost"
      owner = ""
      project = ""
    }
  }
  
}