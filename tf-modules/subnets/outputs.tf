output "private_subnet_ids" {
  description = "IDs of the private subnets created"
  value       = { for k, subnet in aws_subnet.subnet : k => subnet.id }
}

output "outpost_subnet_ids" {
  description = "IDs of the outpost subnets created"
  value       = { for k, subnet in aws_subnet.tf_outpost_subnet_edge : k => subnet.id }
}
