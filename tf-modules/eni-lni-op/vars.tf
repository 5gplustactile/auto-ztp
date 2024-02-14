variable "name_digital_twins" {
  type = string
  description = "name of the digital twins (telefonica, uma...)"
  default = ""
  
}
variable "vpc_id_dt" {
    type = string
    description = "vpd id of digital twins"
  
}

variable "instances" {
  type = map(string)
  description = "Map of instance IDs to CIDR blocks"
  default = {
    "i-0140033d9575fe44d" = "172.1.8.0/24"
    "i-0e4703f525a1f9482" = "172.1.9.0/24"
  }
}

variable "tags" {
    type = map(string)
    description = "set of tags"
    default = {
        owner = "alvaroandres.anayaamariles@telefonica.com"
        project = "tactile5g"
    }
}