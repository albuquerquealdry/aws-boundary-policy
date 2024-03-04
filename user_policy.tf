module "iam_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name_prefix  = "s3_read_write_policy"
  path         = "/"
  description  = "s3_read_write_policy"
  policy       = jsonencode({
    Version    = "2012-10-17",
    Statement  = [
      {
        Sid       = "ListObjectsInBucket",
        Effect    = "Allow",
        Action    = ["s3:ListBucket"],
        Resource  = "*"
      },
      {
        Sid       = "AllObjectActions",
        Effect    = "Allow",
        Action    = "s3:*Object",
        Resource  = "*"
      }
    ]
  })
  tags = local.tags
}