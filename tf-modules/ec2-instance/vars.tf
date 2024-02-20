variable "instances" {
  description = "Map of ec2 instances"
  type = map(object({
    private_ip = string
    instance_in_edge = bool
  }))
  default = {
    "instance-example" = {
      private_ip = "172.0.5.10"
      instance_in_edge = true
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

variable "instance_type_region" {
    type = string
    description = "type instace"
    default = "t3.medium"
}

variable "vpc_id" {
    type = string
    description = "vpc id"
    default = ""
  
}

variable "vpc_name_dc" {
    type = string
    description = "name of vpc to the central data center"
    default = "new-tf-vpc-outpost"
  
}

variable "vpc_cidr" {
    type = string
    description = "cird to vpc"
    default = "172.0.0.0/16"
  
}

variable "tags" {
    type = map(string)
    description = "set of tags"
    default = {
        owner = ""
        environment = ""
        project = ""
    }
  
}

variable "cidr_block_snet_op_region" {
  type = string
  description = "value of the cidr to the subnet created in the outpost. This subnet will be used to connect the instances to region. Please keep in mind the var.vpc_cidr variable"
  default  = "127.0.0.1/24"
  
}