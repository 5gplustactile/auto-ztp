variable "instances" {
  description = "Map of ec2 instances"
  type = map(object({
    instance_in_edge = bool
    ami = string
  }))
  default = {
    "instance-example" = {
      instance_in_edge = true
      ami = "ami-05b5a865c3579bbc4"
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
    description = "instance type if instance_in_edge is false"
    default = "t3.medium"
}

variable "vpc_id" {
    type = string
    description = "vpc id"
    default = ""
  
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
  description = "If instance_in_edge true. Cidr subnet to the subnet created in outpost"
  default  = "127.0.0.1/24"
  
}

variable "cidr_block_snet_op_local" {
  type = string
  description = "If instance_in_edge true. Cidr subnet to the subnet created in outpost used for the local network interface (lni)"
  default  = "127.0.0.2/24"
  
}

variable "cidr_private_subnet" {
  type = string
  description = "If instance_in_edge false. It is the cidr of the vpc to attach the instance in specific private network"
  
}

variable "nat_gw_id" {
  type = string
  description = "nat gateway id of the vpc dc"
  default = ""
  
}