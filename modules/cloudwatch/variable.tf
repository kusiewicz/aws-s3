variable "cloudwatch_role_name" {
  description = "The name of the IAM role for CloudWatch"
  type        = string
}

variable "cloudwatch_policy_name" {
  description = "The name of the CloudWatch log group"
  type        = string
}


variable "iclude_global_events" {
  description = "Whether to include global service events in the CloudTrail log"
  type        = bool
}

variable "invoice_storage_bucket_name" {
  description = "The name of the S3 bucket for invoices"
  type        = string
}


variable "bucket_id" {
  description = "The ID of the S3 bucket"
  type        = string
}

variable "bucket_policy_id" {
  description = "The ID of the S3 bucket policy"
  type        = string
}
