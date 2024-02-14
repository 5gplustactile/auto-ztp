output "vpc_digital_twins_id" {
    description = "Id vpc digital twins"
    value = module.vpc.vpc_id
  
}

output "vpc_digital_twins_arn" {
    description = "Arn vpc digital twins"
    value = module.vpc.vpc_arn
  
}

output "vpc_digital_tiwns_igw_id" {
    description = "Id internet gatway of digital twins"
    value = module.vpc.igw_id
  
}

output "vpc_digital_tiwns_igw_arn" {
    description = "Arn internet gatway of digital twins"
    value = module.vpc.igw_arn
  
}

output "vpc_digital_tiwns_natgw_id" {
    description = "Id nat gateway of digital twins"
    value = module.vpc.natgw_ids
  
}

output "vpc_digital_twins_natgw_eni_ids" {
  description = "List of Network Interface IDs assigned to NAT Gateways"
  value = module.vpc.natgw_interface_ids
  
}