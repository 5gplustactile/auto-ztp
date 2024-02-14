# Create an IAM group
resource "aws_iam_group" "gp" {
  name = var.name_group
}

# Attach the policies to the IAM group using count
resource "aws_iam_group_policy_attachment" "iam_polict_attach" {
  count      = length(var.policies)
  group      = aws_iam_group.gp.name
  policy_arn = var.policies[count.index]
}