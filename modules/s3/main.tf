resource "aws_s3_bucket" "invoices" {
  bucket = var.invoices

  tags = {
    name = var.invoices
  }
}

resource "aws_s3_bucket_public_access_block" "invoices" {
  bucket = aws_s3_bucket.invoices.id

  block_public_acls   = var.block_public_acls
  block_public_policy = var.block_public_policy
}

resource "aws_s3_bucket_versioning" "invoices" {
  bucket = aws_s3_bucket.invoices.id

  versioning_configuration {
    status = "Enabled"
    # mfa_delete = "Enabled"
  }
}


resource "aws_s3_bucket_lifecycle_configuration" "invoices" {
  bucket = aws_s3_bucket.invoices.id

  rule {
    id = "1st-rule"

    transition {
      days          = var.days_after_trasition_to_standard_ia
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = var.days_after_trasition_to_glacier
      storage_class = "GLACIER"
    }

    noncurrent_version_transition {
      noncurrent_days = var.days_after_noncurrent_version_trasition_to_standard_ia
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_transition {
      noncurrent_days = var.days_after_noncurrent_version_trasition_to_glacier
      storage_class   = "GLACIER"
    }

    expiration {
      days = var.days_after_expiration
    }

    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "invoices" {
  bucket = aws_s3_bucket.invoices.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    sid       = "EnforceHttps"
    effect    = "Deny"
    actions   = ["s3:*"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.invoices.bucket}/*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }

  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.invoices.bucket}"]
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.invoices.bucket}/AWSLogs/${var.account_id}/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_s3_bucket_policy" "invoices" {
  bucket = aws_s3_bucket.invoices.id
  policy = data.aws_iam_policy_document.s3_policy.json
}
