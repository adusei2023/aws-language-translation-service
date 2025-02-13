resource "aws_iam_role" "lambda_execution_role" {
  name = "${var.project}-${var.environment}-LambdaRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-LambdaRole"
    }
  )
}

resource "aws_iam_policy" "lambda_policy" {
  name = "${var.project}-${var.environment}-LambdaPolicy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "LogPermissions"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow",
        Resource = "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${aws_lambda_function.lambda_function.function_name}:*"
      },
      {
        Sid = "S3Access"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ],
        Effect = "Allow",
        Resource = [
          "${var.request_bucket_arn}/*",
          "${var.response_bucket_arn}/*",
          "${var.request_bucket_arn}",
          "${var.response_bucket_arn}",
        ]
      },
      {
        Sid = "TranslateServiceAccess"
        Action = [
          "translate:TranslateText"
        ],
        Effect   = "Allow",
        Resource = "*" # Lambda can translate any text
      },
      {
        Sid = "KMSAccess"
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ],
        Effect   = "Allow",
        Resource = "*" # Lambda can decrypt data keys for encryption
      }
    ]
  })

  tags = {
    Name = "${var.project}-${var.environment}-LambdaPolicy"
  }
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
