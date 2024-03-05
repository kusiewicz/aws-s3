terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.region
}

module "iam" {
  source = "./modules/iam"
}

module "cloudwatch" {
  source                      = "./modules/cloudwatch"
  iclude_global_events        = true
  invoice_storage_bucket_name = module.s3.bucket_name
  bucket_id                   = module.s3.bucket_id
  bucket_policy_id            = module.s3.bucket_policy_id
  cloudwatch_role_name        = "cloudwatch-role"
  cloudwatch_policy_name      = "cloudwatch-policy"
}

module "s3" {
  source                                                 = "./modules/s3"
  invoices                                               = "kusy-invoices-bucket"
  account_id                                             = module.iam.account_id
  days_after_trasition_to_standard_ia                    = 30
  days_after_trasition_to_glacier                        = 365
  days_after_noncurrent_version_trasition_to_standard_ia = 30
  days_after_noncurrent_version_trasition_to_glacier     = 365
  days_after_expiration                                  = 1825 // 5 years
  block_public_acls                                      = true
  block_public_policy                                    = true
}
