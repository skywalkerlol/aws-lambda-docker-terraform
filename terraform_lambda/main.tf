resource "aws_lambda_function" "container_lambda" {
  function_name = var.function_name
  role          = aws_iam_role.lambda_role.arn
  package_type  = "Image"
  image_uri     = var.image_uri
  
  timeout      = var.timeout
  memory_size  = var.memory_size
  reserved_concurrent_executions = var.reserved_concurrency

  tracing_config {
    mode = "Active"
  }

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  dead_letter_config {
    target_arn = aws_sqs_queue.dlq.arn
  }

  environment {
    variables = var.environment_variables
  }

  kms_key_arn = aws_kms_key.lambda_key.arn
}

# IAM role for Lambda execution
resource "aws_iam_role" "lambda_role" {
  name = "${var.function_name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach basic Lambda execution policy
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# CloudWatch Log Group for Lambda logs
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 365 # Set to 1 year per compliance requirement
  kms_key_id       = aws_kms_key.lambda_key.arn
}

# Optional Lambda Function URL
resource "aws_lambda_function_url" "function_url" {
  count              = var.create_function_url ? 1 : 0
  function_name      = aws_lambda_function.container_lambda.function_name
  authorization_type = "AWS_IAM"
}