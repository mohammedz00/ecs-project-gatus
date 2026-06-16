resource "aws_iam_openid_connect_provider" "oidc" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1", "1c58a3a8518e8759bf075b76b750d4f2df264fcd"]

  tags = {
    Service  = "github-actions"
    MangedBy = "terraform"
  }
}

resource "aws_iam_role" "oidc-role" {
  name = "oidc-role"

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