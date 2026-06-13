resource "aws_s3_bucket" "remote_state" {
    bucket = "zenudeen-gatus-app-state"
    force_destroy = false

    tags = {
      Name = "zenudeen-gatus-app-state"
    }
  
}

resource "aws_s3_bucket_public_access_block" "remote_state_access" {
  bucket = aws_s3_bucket.remote_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "remote_state_ownership" {
  bucket = aws_s3_bucket.remote_state.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "remote_state_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.remote_state_ownership]

  bucket = aws_s3_bucket.remote_state.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "remote_state_versioning" {
    bucket = aws_s3_bucket.remote_state.id
    versioning_configuration {
      status = "Enabled"
    }
  
}

resource "aws_s3_bucket_server_side_encryption_configuration" "remote_state_encryption" {
  bucket = aws_s3_bucket.remote_state.id
  

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
    bucket_key_enabled = true
  }
}