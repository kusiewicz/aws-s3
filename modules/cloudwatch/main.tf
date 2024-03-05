resource "aws_iam_role" "cloudwatch" {
  name               = var.cloudwatch_role_name
  assume_role_policy = data.aws_iam_policy_document.cloudwatch_assume.json

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_iam_policy_document" "cloudwatch_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "cloudwatch" {
  name   = var.cloudwatch_policy_name
  role   = aws_iam_role.cloudwatch.id
  policy = data.aws_iam_policy_document.cloudwatch_permissions.json
}

data "aws_iam_policy_document" "cloudwatch_permissions" {
  statement {
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents", "logs:PutLogEventsBatch"]
    resources = ["${aws_cloudwatch_log_group.s3_access_logs.arn}:*"]
  }
}

resource "aws_cloudwatch_log_group" "s3_access_logs" {
  name = "/aws/s3/my-invoices-bucket"
}

resource "aws_cloudtrail" "s3_access_logs" {
  name                          = "s3-access-logs"
  s3_bucket_name                = var.invoice_storage_bucket_name
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.s3_access_logs.arn}:*"
  cloud_watch_logs_role_arn     = aws_iam_role.cloudwatch.arn
  include_global_service_events = var.iclude_global_events

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::${var.invoice_storage_bucket_name}/*"]
    }
  }

  depends_on = [var.bucket_id, var.bucket_policy_id, aws_cloudwatch_log_group.s3_access_logs]
}




