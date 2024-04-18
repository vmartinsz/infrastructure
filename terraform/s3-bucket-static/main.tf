provider "aws" {
  region = "us-east-1"
}

variable "bucket_name" {
  type = string
}

resource "aws_s3_bucket" "static_site_bucket" {
  bucket = "static-site-${var.bucket_name}"
  
  tags = {
    Name       = "Static Site Bucket"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_public_access_block" "static_site_bucket_public_access_block" {
  bucket = aws_s3_bucket.static_site_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "static_site_bucket_ownership_controls" {
  bucket = aws_s3_bucket.static_site_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "static_site_bucket_acl" {
  bucket = aws_s3_bucket.static_site_bucket.id
  acl    = "public-read"

  depends_on = [
    aws_s3_bucket_public_access_block.static_site_bucket_public_access_block,
    aws_s3_bucket_ownership_controls.static_site_bucket_ownership_controls,
  ]
}
