output "aws_subnet_ids" {
  description = "The IDs of the subnets"
  value       = { for k, v in aws_subnet.tf_outpost_subnet_edge_local : k => v.id }
}

output "aws_subnet_arns" {
  description = "The ARNs of the subnets"
  value       = { for k, v in aws_subnet.tf_outpost_subnet_edge_local : k => v.arn }
}


output "aws_network_interface_ids" {
  description = "The IDs of the network interfaces"
  value       = { for k, v in aws_network_interface.eni_lni : k => v.id }
}

output "aws_network_interface_arns" {
  description = "The ARNs of the network interfaces"
  value       = { for k, v in aws_network_interface.eni_lni : k => v.arn }
}
