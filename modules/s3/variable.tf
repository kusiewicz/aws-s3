variable "invoices" {
  description = "The name of the S3 bucket for invoices"
  type        = string
}

variable "days_after_trasition_to_standard_ia" {
  description = "The number of days after which to transition objects to the STANDARD_IA storage class"
  type        = number
}

variable "days_after_trasition_to_glacier" {
  description = "The number of days after which to transition objects to the GLACIER storage class"
  type        = number
}

variable "days_after_noncurrent_version_trasition_to_standard_ia" {
  description = "The number of days after which to transition noncurrent object versions to the STANDARD_IA storage class"
  type        = number
}

variable "days_after_noncurrent_version_trasition_to_glacier" {
  description = "The number of days after which to transition noncurrent object versions to the GLACIER storage class"
  type        = number
}

variable "days_after_expiration" {
  description = "The number of days after which to expire objects"
  type        = number
}

variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket"
  type        = bool

}

variable "block_public_policy" {
  description = "Whether Amazon S3 should block public policy for this bucket"
  type        = bool
}

variable "account_id" {
  description = "The ID of the AWS account"
  type        = string
}
