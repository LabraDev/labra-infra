output "alb_security_group_id" {
  description = "Security group ID for the internet-facing ALB."
  value       = aws_security_group.alb.id
}

output "app_security_group_id" {
  description = "Security group ID for the app runtime."
  value       = aws_security_group.app.id
}

output "build_role_arn" {
  description = "IAM role ARN used by build worker processes."
  value       = aws_iam_role.build_worker.arn
}

output "deploy_role_arn" {
  description = "IAM role ARN used by deployment worker processes."
  value       = aws_iam_role.deploy_worker.arn
}

output "build_policy_arn" {
  description = "Policy ARN attached to build worker role."
  value       = aws_iam_policy.build_worker.arn
}

output "deploy_policy_arn" {
  description = "Policy ARN attached to deploy worker role."
  value       = aws_iam_policy.deploy_worker.arn
}
