output "ec2_masters_ids" {
  description = "The IDs of the EC2 masters"
  value       = { for k, v in module.ec2_instance : k => v.id }
}

output "ec2_masters_arns" {
  description = "The ARNs of the EC2 masters"
  value       = { for k, v in module.ec2_instance : k => v.arn }
}

output "ec2_workers_ids" {
  description = "The IDs of the EC2 workers"
  value       = { for k, v in module.ec2_instance_workers : k => v.id }
}

output "ec2_workers_arns" {
  description = "The ARNs of the EC2 workers"
  value       = { for k, v in module.ec2_instance_workers : k => v.arn }
}

output "sgs_rke2_cluster_arn" {
    description = "Arn rke2 cluster security group"
    value = aws_security_group.rke2_cluster_sgs.arn
  
}

output "sgs_rke2_cluster_id" {
    description = "Id rke2 cluster security group"
    value = aws_security_group.rke2_cluster_sgs.id
  
}

output "sgs_lni_interface_arn" {
    description = "Arn lni interface security group"
    value = module.security_group.security_group_arn
  
}

output "sgs_lni_interface_id" {
    description = "Id lni interface security group"
    value = module.security_group.security_group_id
  
}

output "sgs_vpc_peering_arn" {
  description = "Arn vpc peering security group"
  value       = var.cidr_block_vpc_digital_twins != null && var.cidr_block_vpc_digital_twins != "" ? aws_security_group.sgs_vpc_peering[0].arn : null
}

output "sgs_vpc_peering_id" {
  description = "Id vpc peering security group"
  value       = var.cidr_block_vpc_digital_twins != null && var.cidr_block_vpc_digital_twins != "" ? aws_security_group.sgs_vpc_peering[0].id : null
}

output "vpc_id" {
    description = "Id of vpc"
    value = module.vpc.vpc_id
  
}

output "vpc_arn" {
    description = "Arn of vpc"
    value = module.vpc.vpc_arn
  
}

output "vpc_igw_arn" {
  description = "Arn Internet gateway"
  value = module.vpc.igw_arn
  
}

output "vpc_igw_id" {
  description = "Id Internet gateway"
  value = module.vpc.igw_id
  
}

output "vpc_natgw_id" {
  description = "Id Internet gateway"
  value = module.vpc.natgw_ids
  
}

output "vpc_natgw_eni_ids" {
  description = "List of Network Interface IDs assigned to NAT Gateways"
  value = module.vpc.natgw_interface_ids
  
}

output "load_balancer_arn" {
    description = "Arn Load Balancer rk2 cluster"
    value = aws_lb.nlb.arn
  
}

output "load_balancer_id" {
    description = "Id Load Balancer rk2 cluster"
    value = aws_lb.nlb.id
  
}

output "bastion_host_id" {
  description = "The ID of the bastion host"
  value       = var.enable_bastion_host ? module.bastion_host[0].id : ""

}

output "bastion_host_name" {
  description = "The name of the bastion host"
  value       = var.name_bastion_host
  
}

output "bucket_arn" {
  description = "Arn Bucket Config files"
  value       = aws_s3_bucket.bucket.arn
  
}