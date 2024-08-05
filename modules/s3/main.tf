resource "aws_s3_bucket" "data_bucket" {
  bucket = "${var.prefix}_data_bucket"

  tags = {
    Environment = var.environment
  }
}

resource "aws_s3_bucket_public_access_block" "data_bucket" {
  bucket = aws_s3_bucket.data_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
