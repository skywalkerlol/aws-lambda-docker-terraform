provider "aws" {
  region = "us-east-2"
}

# Reference to the ECR repository
data "aws_ecr_repository" "app_repo" {
  name = "app-10" # This should match the name in terraform_ecr/variables.tf
}

# Get the latest image
data "aws_ecr_image" "app_image" {
  repository_name = data.aws_ecr_repository.app_repo.name
  image_tag       = "latest"
}

# Deploy Lambda using the container image
module "container_lambda" {
  source = "../terraform_lambda"
  
  function_name = "container-lambda-example"
  image_uri     = "${data.aws_ecr_repository.app_repo.repository_url}:latest"
  
  memory_size   = 256
  timeout       = 60
  create_function_url = true
  
  environment_variables = {
    ENVIRONMENT = "dev"
  }
}

output "lambda_function_url" {
  value = module.container_lambda.lambda_function_url
}