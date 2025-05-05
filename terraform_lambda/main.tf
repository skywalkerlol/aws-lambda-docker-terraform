resource "aws_lambda_function" "container_lambda" {
  function_name = var.function_name
  role          = aws_iam_role.lambda_role.arn
  package_type  = "Image"
  image_uri     = var.image_uri
  
  timeout     = var.timeout
  memory_size = var.memory_size

  environment {
    variables = var.environment_variables
  }
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
  retention_in_days = var.log_retention_days
}

# Optional Lambda Function URL
resource "aws_lambda_function_url" "function_url" {
  count              = var.create_function_url ? 1 : 0
  function_name      = aws_lambda_function.container_lambda.function_name
  authorization_type = "NONE"
}