data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_availability_zones" "available" {}
data "aws_vpc" "vpc_dc" {
  id = var.vpc_id
}