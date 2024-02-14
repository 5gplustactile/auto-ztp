variable "policies" {
    type = list(string)
    default = [""]
    description = "list of the arn policies attached in group"
}

variable "name_group" {
    type = string
    default = ""
    description = "name of the group"
}