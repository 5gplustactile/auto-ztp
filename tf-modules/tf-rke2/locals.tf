locals {

  list_ec2 = [ for v in values(module.ec2_instance): v.id ]
  list_ec2_workers = [ for v in values(module.ec2_instance_workers): v.id ]
  list_private_ips = [ for p in values(var.masters): p.private_ip ]
  list_private_ips_workers = [ for p in values(var.workers): p.private_ip ]
  control_plane_in_edge = contains([for v in values(var.masters) : v.control_plane_in_edge], true)
  worker_in_edge = contains([for v in values(var.workers) : v.worker_in_edge], true)
  edge_masters = [for k, v in var.masters : k if v.control_plane_in_edge]
  edge_workers = [for k, v in var.workers : k if v.worker_in_edge]
  edge_master_ips = [for k, v in var.masters : v.private_ip if v.control_plane_in_edge]
  edge_worker_ips = [for k, v in var.workers : v.private_ip if v.worker_in_edge]
  master_in_edge_ids = { for k, v in module.ec2_instance : k => v.id if var.masters[k].control_plane_in_edge }
  worker_in_edge_ids = { for k, v in module.ec2_instance_workers : k => v.id if var.workers[k].worker_in_edge }
  account_id          = data.aws_caller_identity.current.account_id
  region              = data.aws_region.current.name
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
  username = data.aws_caller_identity.current.user_id
  ami = "ami-05b5a865c3579bbc4"
  instance_type_outpost = "c6id.2xlarge"
  instance_type_region = "t3.medium"
  outpost_arn = "arn:aws:outposts:eu-west-3:774986117405:outpost/op-067dcd1b4637f98ab"
  root_block_device = [
    {
      volume_type           = "gp2"
      volume_size           = 100
      delete_on_termination = true
    }
  ]
  
}