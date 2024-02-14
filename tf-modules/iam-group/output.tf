output "iam_group" {
    value = aws_iam_group.gp.name
    description = "name of the group"
}