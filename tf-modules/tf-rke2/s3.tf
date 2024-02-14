resource "aws_s3_bucket" "bucket" {
  bucket = "mgmt-config-files"

}

#resource "aws_s3_bucket_acl" "acl" {
#  bucket = aws_s3_bucket.bucket.id
#  acl    = "private"
#}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.bucket.id 
  key    = "amazon-cloudwatch-agent.json"  # replace with your file name
  source = "./config/amazon-cloudwatch-agent.json"  # replace with the path to your local file
  acl    = "private"
}

data "aws_iam_policy_document" "s3" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.bucket.arn}/*"]
  }
}

resource "aws_iam_policy" "s3" {
  name        = "S3AccessPolicy"
  description = "An IAM policy to allow an EC2 instance to access an S3 bucket"
  policy      = data.aws_iam_policy_document.s3.json
}
