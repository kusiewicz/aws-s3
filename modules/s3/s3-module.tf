// with no vars here, just to look how s3 ready module looks like :)

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 2.0"

  bucket = "invoices"
  acl    = "private"

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "aws:kms"
      }
    }
  }

  lifecycle_rule = [
    {
      id      = "1st-rule"
      status  = "Enabled"
      enabled = true

      transition = [
        {
          days          = 30
          storage_class = "STANDARD_IA"
        },
        {
          days          = 365
          storage_class = "GLACIER"
        },
      ]

      noncurrent_version_transition = [
        {
          noncurrent_days = 30
          storage_class   = "STANDARD_IA"
        },
        {
          noncurrent_days = 365
          storage_class   = "GLACIER"
        },
      ]

      expiration = {
        days = 1925
      }
    }
  ]

  policy = data.aws_iam_policy_document.s3_policy.json
}
