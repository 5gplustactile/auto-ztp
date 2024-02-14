variable "vpc_cidr" {
    type = string
    description = "cird to vpc"
  
}

variable "vpc_name" {
    type = string
    description = "name of vpc"
  
}

variable "cidr_block_vpc_cluster_dc" {
    type = string
    description = "cidr block of the cluster-dc"
  
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