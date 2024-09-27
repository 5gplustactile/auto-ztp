variable "vpc_cidr" {
    type = string
    description = "cird to vpc"
    default = "172.0.0.0/16"
  
}

variable "vpc_private_subnets" {
    type = list(string)
    description = "list of private subnets of vpc wavelength"
    default = ["172.2.1.0/24", "172.2.2.0/24"]
  
}

variable "vpc_public_subnets" {
    type = list(string)
    description = "list of public subnets of vpc wavelength"
    default = ["172.2.48.0/24", "172.2.49.0/24"]
  
}

variable "vpc_cidr_wvl" {
    type = string
    description = "cird vpc to wavelength"
    default = "172.1.0.0/16"
  
}

variable "private_subnets_wvl" {
    type = list(string)
    description = "list of private subnets of vpc wavelength"
    default = ["172.1.1.0/24", "172.1.2.0/24"]
  
}

variable "public_subnets_wvl" {
    type = list(string)
    description = "list of public subnets of vpc wavelength"
    default = ["172.1.48.0/24", "172.1.49.0/24"]
  
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

variable "cidr_block_snet_wvl" {
    type = string
    description = "value of the cidr to the subnet created in the wavelength. This subnet will be used to connect the instances in wavelength zone with others ones. Please keep in mind the var.vpc_cidr variable"
    default = "172.0.6.0/24"
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
    zone = string
  }))
  default = {
    "backup-cluster-mgmt-rke2-worker-0" = {
      private_ip = "172.0.5.12"
      zone = "edge"  #cloud be edge or wvl
    }
    "backup-cluster-mgmt-rke2-worker-1" = {
      private_ip = "172.0.5.13"
      zone = "wvl"
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

variable "outpost_arn" {
  description = "outpost arn"
  type = string
  default = ""
  
}

variable "ami" {
  description = "ami of iamge in aws"
  type = string
  default = ""
  
}

variable "instance_type_region" {
  description = "instance type in aws region"
  type = string
  default = "t3.medium"
  
}

variable "instance_type_outpost" {
  description = "instance type in aws outpost"
  type = string
  default = "c6id.2xlarge"
  
}