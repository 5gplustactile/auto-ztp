# iam role and policies to worker nodes

resource "aws_iam_role" "ec2_instance_role" {
  name = "ec2_instance_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "AmazonSSMManagedInstanceCore" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "AWSLoadBalancerControllerIAMPolicy" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = aws_iam_policy.aws_lb_controller.arn
}

resource "aws_iam_role_policy_attachment" "AWSRKE2Policy" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = aws_iam_policy.rke2_policy.arn
}

resource "aws_iam_role_policy_attachment" "CloudWatchAgentServerRole" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "S3AccessPolicy" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/S3AccessPolicy"
}


resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_instance_role.name

  tags = var.tags
}