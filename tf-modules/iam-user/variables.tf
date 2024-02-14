
variable "password_reset_required" {
  description = "Whether the user should be forced to reset the generated password on first login."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "When destroying this user, destroy even if it has non-Terraform-managed IAM access keys, login profile or MFA devices. Without force_destroy a user with non-Terraform-managed access keys and login profile will fail to be destroyed."
  type        = bool
  default     = false
}

variable "name" {
  description = "Desired name for the IAM user"
  type        = string
  default = ""
}

variable "role_name" {
  description = "Desired name for the role"
  type        = string
  default     = ""
}

variable "role_description" {
  description = "Desired description for the role"
  type        = string
  default     = ""
}

variable "create_iam_access_key" {
  description = "Access key."
  type        = bool
  default     = false
}

variable "policies" {
  type = list(object({
    name             = string,
    policy_as_object = any
  }))
  default = []
}

variable "default_policies" {
  type    = list(string)
  default = []
}

variable "user_groups" {
  description = "List of groups"
  type        = list(map(string))
  default     = []
}
variable "aws_account_id" {
  description = "Account ID"
  type        = string
  default = ""
}

variable "attach_group" {
  description = "If set to true, enable group attachment."
  type        = bool
  default     = false
}
