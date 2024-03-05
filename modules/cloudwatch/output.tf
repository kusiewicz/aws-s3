output "cloudwatch_log_group_arn" {
  value       = aws_cloudwatch_log_group.s3_access_logs.arn
  description = "The ARN of the CloudWatch log group"
}
