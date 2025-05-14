# # lambda.tf
# resource "aws_lambda_function" "container_lambda" {
#   function_name = "${var.name}-lambda"
#   role          = aws_iam_role.lambda_role.arn
#   package_type  = "Image"
#   image_uri     = "${aws_ecr_repository.this.repository_url}:latest"

#   memory_size = 128
#   timeout     = 30

#   environment {
#     variables = {
#       ENVIRONMENT = "production"
#     }
#   }
# }

# # IAM role for Lambda
# resource "aws_iam_role" "lambda_role" {
#   name = "${var.name}-lambda-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "lambda.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# # Basic Lambda execution policy
# resource "aws_iam_role_policy_attachment" "lambda_basic" {
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
#   role       = aws_iam_role.lambda_role.name
# }

# # ECR access policy for Lambda
# resource "aws_iam_role_policy" "lambda_ecr_access" {
#   name = "${var.name}-lambda-ecr-access"
#   role = aws_iam_role.lambda_role.id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "ecr:GetDownloadUrlForLayer",
#           "ecr:BatchGetImage"
#         ]
#         Resource = [aws_ecr_repository.this.arn]
#       }
#     ]
#   })
# }