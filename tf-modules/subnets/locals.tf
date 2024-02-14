locals {

  account_id          = data.aws_caller_identity.current.account_id
  region              = data.aws_region.current.name
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
  outpost_arn = "arn:aws:outposts:eu-west-3:774986117405:outpost/op-067dcd1b4637f98ab"
  snet_tf_op_region = [ for p in values(var.subnet_outpost): p.cidr_block_snet_op_region ]

  flattened_subnets = flatten([
    for dt, details in var.subnet_region : [
      for i in range(length(details.cidr_region)) : {
        dt          = dt
        cidr_block  = details.cidr_region[i]
        az          = details.az[i]
      }
    ]
  ])

  
}