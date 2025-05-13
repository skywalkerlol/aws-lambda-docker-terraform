# Code signing configuration for Lambda function
resource "aws_signer_signing_profile" "lambda_signing" {
  name_prefix = "lambda_signing"
  platform_id = "AWSLambda-SHA384-ECDSA"
}

# Attach code signing config to Lambda function
resource "aws_lambda_code_signing_config" "lambda_signing_config" {
  allowed_publishers {
    signing_profile_version_arns = [aws_signer_signing_profile.lambda_signing.arn]
  }

  policies {
    untrusted_artifact_on_deployment = "Enforce"
  }
}

# Associate Lambda function with code signing config
resource "aws_lambda_function_code_signing_config" "lambda_code_signing" {
  code_signing_config_arn = aws_lambda_code_signing_config.lambda_signing_config.arn
  function_name          = aws_lambda_function.container_lambda.function_name
}