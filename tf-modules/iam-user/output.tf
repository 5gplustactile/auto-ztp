
output "iam_access_key_id" {
  description = "The access key ID"
  value       = module.iam_user.iam_access_key_id
}

output "iam_access_key_secret" {
  description = "The access key secret"
  value       = module.iam_user.iam_access_key_secret
  sensitive   = true
}

output "user_arn" {
  value       = module.iam_user.iam_user_arn
  description = "User ARN"
}

output "iam_user_login_profile_password" {
  description = "The user password"
  value       = module.iam_user.iam_user_login_profile_password
  sensitive   = true
}

# output "role_arn" {
#   value       = aws_iam_role.role.arn
#   description = "Role ARN"
# }

output "role_arn" {
  value = length(var.role_name) > 0 ? aws_iam_role.role[0].arn : null
}
