variable "vpc_id_cluster_dc" {
    type = string
    description = "vpc id of the cluster-dc"
  
}

variable "vpc_id_dt" {
    type = string
    description = "vpc id of vpc the digital-twins"
  
}

variable "tags" {
    type = map(string)
    description = "set of tags"
    default = {
        owner = "alvaroandres.anayaamariles@telefonica.com"
        project = "tactile5g"
    }
  
}

variable "cluster_dc_private_subnets" {
  type = list(string)
  description = "list of the private subnets"
#  default = [ "subnet-0b75599f3fc14b247", "subnet-068080e8e5df32d80", "subnet-07f6dae98681dd140" ]
  
}

variable "list_route_table_id_cluster_dc" {
  type = list(string)
  description = "list route table id of the cluster dc vpc to the private/outpost networks"
  default = ["rtb-0c8f03b5d22bb36a7","rtb-0c8f03b5d22bb312317","rtb-0c8f032313122bb36a7"]
}

variable "dest_cidr" {
  type = string
  description = "cidr block of vpc digital twins"
  default = "172.1.0.0/16"
  
}

variable "cidr_block_vpc_cluster_dc" {
  type = string
  description = "cidr block of vpc cluster dc"
  default = "172.0.0.0/16"
  
}

variable "rt_id_private_digital_twins" {
  type = string
  description = "route table id of the private networks digital twins"
  default = "rtb-00bee61da9983cd54"
  
}