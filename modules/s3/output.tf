output "bucket_name" {
  value = aws_s3_bucket.invoices.id
}

output "bucket_id" {
  value = aws_s3_bucket.invoices.id
}

output "bucket_policy_id" {
  value = aws_s3_bucket_policy.invoices.id
}
