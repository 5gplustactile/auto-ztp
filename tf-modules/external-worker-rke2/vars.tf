variable "workers" {
  description = "Map of worker nodes"
  type = map(object({
    private_ip = string
    worker_in_edge = bool
  }))
  default = {
    "backup-cluster-mgmt-rke2-worker-0" = {
      private_ip = "172.0.5.12"
      worker_in_edge = true
    }
    "backup-cluster-mgmt-rke2-worker-1" = {
      private_ip = "172.0.5.13"
      worker_in_edge = true
    }
  }
}

variable "key_name" {
    type = string
    description = "name of key"
    default = "tactile5g" 
}

variable "monitoring" {
    type = bool
    description = "true/false enabling monitoring"
    default = true
}

variable "vpc_cidr" {
    type = string
    description = "cird vpc of the cluster dc/mgmt"
    default = "172.0.0.0/16"
  
}

variable "ext_vpc_id" {
    type = string
    description = "vpc external id, ex: vpc digital twins"
    default = "vpc-08291124993d8220b"
  
}

variable "tags" {
    type = map(string)
    description = "set of tags"
    default = {
        owner = "alvaroandres.anayaamariles@telefonica.com"
        environment = "Outpost-edge"
        project = "tactile5g"
    }
  
}

variable "cidr_block_snet_op_region" {
    type = string
    description = "value of the cidr to the subnet created in the outpost. This subnet will be used to connect the instances to region. Please keep in mind the var.vpc_cidr variable"
    default = "172.1.4.0/24"
  
}

variable "cidr_block_snet_op_local" {
    type = string
    description = "value of the cidr to the subnet created in the outpost. This subnet will be used to connect the instances to on-premise. Please keep in mind the var.vpc_cidr variable"
    default = "172.1.5.0/24"
  
}

variable "name_lb" {
  type = string
  description = "name of the lb, must be the same like load balancer of the cluster dc/mgmt"
  default = "new-nlb-tf"
  
}

variable "natgw_id" {
  type = string
  description = "nat gateway associated to the var.ext_vpc_id"
  default = ""
  
}

variable "route_table_id" {
  type = string
  description = "route table id of the private subnets of the vpc digital twins vpc"
  default = ""
  
}