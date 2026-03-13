# ALB security group allows inbound HTTP from the internet.
# Frontend : the "live URL" eventually resolves through this ALB path.
resource "aws_security_group" "alb" {
  name        = "${var.name_prefix}-alb-sg"
  description = "Ingress for public ALB traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Public HTTP access for MVP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ALB can reach downstream targets and AWS APIs as needed.
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-alb-sg"
  })
}

# App security group only allows traffic from ALB on app_port.
# Backend : if app_port changes in deploy config, this SG must stay in sync.
resource "aws_security_group" "app" {
  name        = "${var.name_prefix}-app-sg"
  description = "Ingress from ALB to app runtime"
  vpc_id      = var.vpc_id

  ingress {
    description     = "App traffic from ALB only"
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  # App runtime requires outbound access (for image pulls, logs, APIs, etc.).
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-app-sg"
  })
}

# Build role trust policy (ECS task principal for now).
# Backend/CI : this is the role our build worker should assume.
data "aws_iam_policy_document" "build_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "build_worker" {
  name               = "${var.name_prefix}-build-role"
  assume_role_policy = data.aws_iam_policy_document.build_assume_role.json

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-build-role"
  })
}

# Build permissions (intentionally broad for MVP):
# - ECR auth/push operations for image publication
# - CloudWatch Logs write for build logs
# - S3 read/write for artifacts
# Backend/CI : once repo/bucket names are fixed, we should replace "*" here.
data "aws_iam_policy_document" "build_permissions" {
  statement {
    sid    = "EcrPushPull"
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "WriteBuildLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "ArtifactStorage"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "build_worker" {
  name        = "${var.name_prefix}-build-policy"
  description = "Build worker policy for image publishing and artifact/log access"
  policy      = data.aws_iam_policy_document.build_permissions.json
}

resource "aws_iam_role_policy_attachment" "build_worker" {
  role       = aws_iam_role.build_worker.name
  policy_arn = aws_iam_policy.build_worker.arn
}

# Deploy role trust policy (ECS task principal for now).
# Backend/CI : deploy worker should assume this role for ECS rollouts.
data "aws_iam_policy_document" "deploy_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "deploy_worker" {
  name               = "${var.name_prefix}-deploy-role"
  assume_role_policy = data.aws_iam_policy_document.deploy_assume_role.json

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-deploy-role"
  })
}

# Deploy permissions (MVP baseline):
# - ECS service/task definition update operations
# - IAM PassRole for ECS task/execution roles during deployment
# Backend/CI : same as build role, we should scope resources once ARNs settle.
data "aws_iam_policy_document" "deploy_permissions" {
  statement {
    sid    = "EcsDeployActions"
    effect = "Allow"
    actions = [
      "ecs:DescribeClusters",
      "ecs:DescribeServices",
      "ecs:DescribeTaskDefinition",
      "ecs:RegisterTaskDefinition",
      "ecs:UpdateService"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "PassRolesToEcs"
    effect = "Allow"
    actions = [
      "iam:PassRole"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "ReadDeploymentLogs"
    effect = "Allow"
    actions = [
      "logs:GetLogEvents",
      "logs:DescribeLogStreams"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "deploy_worker" {
  name        = "${var.name_prefix}-deploy-policy"
  description = "Deploy worker policy for ECS rollout actions"
  policy      = data.aws_iam_policy_document.deploy_permissions.json
}

resource "aws_iam_role_policy_attachment" "deploy_worker" {
  role       = aws_iam_role.deploy_worker.name
  policy_arn = aws_iam_policy.deploy_worker.arn
}
