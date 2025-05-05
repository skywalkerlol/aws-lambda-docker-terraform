output "lambda_function_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.container_lambda.arn
}

output "lambda_function_name" {
  description = "The name of the Lambda function"
  value       = aws_lambda_function.container_lambda.function_name
}

output "lambda_role_arn" {
  description = "The ARN of the IAM role created for the Lambda function"
  value       = aws_iam_role.lambda_role.arn
}

output "lambda_invoke_arn" {
  description = "The invoke ARN of the Lambda function"
  value       = aws_lambda_function.container_lambda.invoke_arn
}

output "lambda_function_url" {
  description = "The URL of the Lambda function (if configured)"
  value       = var.create_function_url ? aws_lambda_function_url.function_url[0].function_url : null
}