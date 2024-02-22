locals {
  edge_instances = [for k, v in var.instances : k if v.instance_in_edge]
  instance_in_edge_ids = { for k, v in module.ec2_instance : k => v.id if var.instances[k].instance_in_edge }
  instance_type_outpost = "c6id.2xlarge"
  outpost_arn = "arn:aws:outposts:eu-west-3:774986117405:outpost/op-067dcd1b4637f98ab"
  region = data.aws_region.current.name
  root_block_device = [
    {
      volume_type           = "gp2"
      volume_size           = 100
      delete_on_termination = true
    }
  ]
}