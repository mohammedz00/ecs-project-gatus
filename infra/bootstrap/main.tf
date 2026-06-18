# S3 bucket remote backend setup

resource "aws_s3_bucket" "remote_state" {
  bucket        = "zenudeen-gatus-app-state"
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
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}


# ECR repository setup
resource "aws_ecr_repository" "gatus-ecr-repo" {
  name                 = "zenudeen-gatus-ecr"
  image_tag_mutability = "MUTABLE"

  encryption_configuration {

    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = true
  }

}


# OIDC 

resource "aws_iam_openid_connect_provider" "oidc" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1", "1c58a3a8518e8759bf075b76b750d4f2df264fcd"]

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Service  = "github-actions"
    MangedBy = "terraform"
  }
}

resource "aws_iam_role" "oidc-role" {
  name                 = "oidc-role"
  max_session_duration = 7200
  lifecycle {
    prevent_destroy = true
  }

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.oidc.arn
        }
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:mohammedz00/ecs-project-gatus:*"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "oidc-role-policy-attachment" {
  role       = aws_iam_role.oidc-role.name
  policy_arn = var.oidc-policy_arn
}

variable "oidc-policy_arn" {
  type        = string
  description = "The OIDC policy ARN"
  default     = "arn:aws:iam::aws:policy/AdministratorAccess"

}