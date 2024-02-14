locals {
  account_id          = data.aws_caller_identity.current.account_id
  region              = data.aws_region.current.name
  outpost_arn = "arn:aws:outposts:eu-west-3:774986117405:outpost/op-067dcd1b4637f98ab"
}