locals {
  user_groups_map = { for group in var.user_groups : group["name"] => group }
}

module "iam_user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "5.27.0"

  name                  = var.name
  force_destroy         = var.force_destroy
  create_iam_access_key = var.create_iam_access_key

  password_reset_required = var.password_reset_required
}

resource "aws_iam_policy" "policy" {
  for_each = { for policy in var.policies : policy.name => policy }
  name     = each.value.name

  policy = jsonencode(each.value.policy_as_object)
}

resource "aws_iam_role" "role" {
  count              = length(var.role_name) > 0 ? 1 : 0
  name               = var.role_name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.aws_account_id}:user/${var.name}"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  for_each = length(aws_iam_role.role) > 0 ? { for key, _ in aws_iam_policy.policy : key => null } : {}

  role       = length(aws_iam_role.role) > 0 ? aws_iam_role.role[0].name : null
  policy_arn = length(aws_iam_role.role) > 0 ? aws_iam_policy.policy[each.key].arn : null
}

resource "aws_iam_user_policy_attachment" "user_policy_attachment" {
  for_each = aws_iam_policy.policy

  user       = module.iam_user.iam_user_name
  policy_arn = aws_iam_policy.policy[each.key].arn
}

resource "aws_iam_policy_attachment" "default_attachments" {
  count      = length(var.default_policies) > 0 ? 1 : 0
  name       = var.default_policies[count.index]
  users      = [module.iam_user.iam_user_name]
  policy_arn = "arn:aws:iam::aws:policy/${var.default_policies[count.index]}"
}

resource "aws_iam_user_group_membership" "group_membership" {
  for_each = local.user_groups_map

  user   = module.iam_user.iam_user_name
  groups = length(local.user_groups_map) > 0 ? [local.user_groups_map[each.key].name] : []
}
