# # CloudWatch Log Group for Lambda
# resource "aws_cloudwatch_log_group" "lambda_logs" {
#   name              = "/aws/lambda/${aws_lambda_function.container_lambda.function_name}"
#   retention_in_days = 14
# }