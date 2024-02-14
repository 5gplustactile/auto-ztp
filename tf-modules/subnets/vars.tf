variable "vpc_id_dt" {
    type = string
    description = "vpd id of digital twins"
  
}

variable "cidr_block_vpc_cluster_dc" {
  type = string
  description = "cidr block of the cluster dc vpc"
  default = ""
  
}

variable "route_table_id_cluster_cd" {
  type = string
  description = "route table id of the private networks of the cluster dc"  
  default = "rtb-07bd53803005c5191"
}

variable "route_table_id" {
  type = string
  description = "route table id of the private subnets of the vpc digital twins vpc"
  default = ""
  
}

variable "tags" {
    type = map(string)
    description = "set of tags"
    default = {
        owner = ""
        environment = "Outpost-region"
        project = ""
    }
  
}

variable "subnet_region" {
  description = "Map of subnet details"
  type = map(object({
    cidr_region = list(string)
    az = list(string)
  }))
  default = {
#    "dt-0" = {
#        cidr_region = ["172.1.8.0/24","172.1.9.0/24","172.1.10.0/24"]
#        az = ["eu-west-3a","eu-west-3b","eu-west-3c"]
#    }
#    "dt-1" = {
#        cidr_region = ["172.1.11.0/24","172.1.12.0/24","172.1.13.0/24"]
#        az = ["eu-west-3a","eu-west-3b","eu-west-3c"]
#    }
  }  
}
variable "subnet_outpost" {
  description = "Map of subnets outpost"
  type = map(object({
    cidr_block_snet_op_region = string
  }))
#  default = {
#    "dt-0" = {
#      cidr_block_snet_op_region = "172.1.7.0/24"
#    }
#    "dt-1" = {
#      cidr_block_snet_op_region = "172.1.7.0/24"
#    }
#  }
}