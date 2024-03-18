variable "vpc_cidr" {
    type = string
    description = "cird to vpc"
    default = "172.0.0.0/16"
  
}

variable "vpc_name" {
    type = string
    description = "name of vpc"
    default = "new-tf-vpc-outpost"
  
}

variable "cidr_block_snet_op_region" {
    type = string
    description = "value of the cidr to the subnet created in the outpost. This subnet will be used to connect the instances to region. Please keep in mind the var.vpc_cidr variable"
    default = "172.0.4.0/24"
  
}

variable "cidr_block_snet_op_local" {
    type = string
    description = "value of the cidr to the subnet created in the outpost. This subnet will be used to connect the instances to on-premise. Please keep in mind the var.vpc_cidr variable"
    default = "172.0.5.0/24"
  
}
variable "key_name" {
    type = string
    description = "name of key"
    default = "tactile5g"
  
}

variable "name_bastion_host" {
  type = string
  description = "name of the bastion host"
  default = "bastion-telefonica"
  
}

variable "enable_bastion_host" {
  description = "Enable or disable the creation of the bastion host"
  type        = bool
  default     = true
}


variable "name_lb" {
  type = string
  description = "name of the lb"
  default = "new-nlb-tf"
  
}

variable "monitoring" {
    type = bool
    description = "true/false enabling monitoring"
    default = true
}

variable "masters" {
  description = "Map of master nodes"
  type = map(object({
    private_ip = string
    control_plane_in_edge = bool
  }))
  default = {
    "backup-cluster-mgmt-rke2-master-0" = {
      private_ip = "172.0.5.10"
      control_plane_in_edge = true
    }
    "backup-cluster-mgmt-rke2-master-1" = {
      private_ip = "172.0.5.11"
      control_plane_in_edge = true
    }
  }
}

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

variable "tags" {
    type = map(string)
    description = "set of tags"
    default = {
        owner = "alvaroandres.anayaamariles@telefonica.com"
        environment = "Outpost-edge"
        project = "tactile5g"
    }
  
}

variable "cidr_block_vpc_digital_twins" {
  type = string
  description = "cidr block vpc digital twins"
  default = ""

}

variable "email_list" {
  description = "List of email addresses for SNS notifications"
  type        = list(string)
  default     = ["email1@example.com", "email2@example.com", "email3@example.com"]
}