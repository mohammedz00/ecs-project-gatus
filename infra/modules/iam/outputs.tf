output "oidc-role-arn" {
    value = aws_iam_role.oidc-role.arn
    description = "ARN of OIDC role"
  
}