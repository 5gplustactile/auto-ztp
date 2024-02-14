locals {
  account_id          = data.aws_caller_identity.current.account_id
  region              = data.aws_region.current.name
  outpost_arn = "arn:aws:outposts:eu-west-3:774986117405:outpost/op-067dcd1b4637f98ab"
  ami = "ami-05b5a865c3579bbc4"
  instance_type_outpost = "c6id.2xlarge"
  instance_type_region = "t3.medium"
  worker_in_edge = contains([for v in values(var.workers) : v.worker_in_edge], true)
  edge_workers = [for k, v in var.workers : k if v.worker_in_edge]
  edge_worker_ips = [for k, v in var.workers : v.private_ip if v.worker_in_edge]
  worker_in_edge_ids = { for k, v in module.ec2_instance_workers : k => v.id if var.workers[k].worker_in_edge }
  worker_in_edge_private_ip = { for k, v in module.ec2_instance_workers : k => v.private_ip if var.workers[k].worker_in_edge }
  vpc_dt_private_subnet = "subnet-0d32f54b759126501"
  root_block_device = [
    {
      volume_type           = "gp2"
      volume_size           = 100
      delete_on_termination = true
    }
  ]
}