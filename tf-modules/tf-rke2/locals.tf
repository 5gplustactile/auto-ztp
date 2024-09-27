locals {

  list_ec2 = [ for v in values(module.ec2_instance): v.id ]
  list_ec2_workers = [ for v in values(module.ec2_instance_workers): v.id ]
  list_private_ips = [ for p in values(var.masters): p.private_ip ]
  list_private_ips_workers = [ for p in values(var.workers): p.private_ip ]
  control_plane_in_edge = contains([for v in values(var.masters) : v.control_plane_in_edge], true)
  worker_in_edge = contains([for v in values(var.workers) : v.zone], "edge")
  worker_in_wvl = contains([for v in values(var.workers) : v.zone], "wvl")
  edge_masters = [for k, v in var.masters : k if v.control_plane_in_edge]
  edge_workers = [for k, v in var.workers : k if v.zone == "edge"]
  edge_master_ips = [for k, v in var.masters : v.private_ip if v.control_plane_in_edge]
  edge_worker_ips = [for k, v in var.workers : v.private_ip if v.zone == "edge"]
  master_in_edge_ids = { for k, v in module.ec2_instance : k => v.id if var.masters[k].control_plane_in_edge }
  worker_in_edge_ids = { for k, v in module.ec2_instance_workers : k => v.id if var.workers[k].zone == "edge" }
  account_id          = data.aws_caller_identity.current.account_id
  region              = data.aws_region.current.name
  azs      = ["eu-west-3a", "eu-west-3b", "eu-west-3c"]
  parent_azs_wvl      = ["eu-west-3a", "eu-west-3b"]
  az_wvl = "eu-west-3-pilot-1a"
  username = data.aws_caller_identity.current.user_id
  ami = var.ami
  instance_type_outpost = var.instance_type_outpost
  instance_type_region = var.instance_type_region
  outpost_arn = var.outpost_arn
  az_to_subnet_edge = "eu-west-3a"
  root_block_device = [
    {
      volume_type           = "gp2"
      volume_size           = 80
      delete_on_termination = true
    }
  ]
  
}