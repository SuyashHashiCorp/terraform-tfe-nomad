# Create an S3 bucket with public access
resource "aws_s3_bucket" "tfe_nomad_s3_bucket" {
  bucket = var.s3_bucket_name

  tags = {
    Name = var.s3_bucket_name
  }
}

resource "aws_s3_bucket_ownership_controls" "tfe-nomad-s3-oc" {
  bucket = aws_s3_bucket.tfe_nomad_s3_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "tfe-nomad-s3-oc" {
  bucket = aws_s3_bucket.tfe_nomad_s3_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
