#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key
resource "aws_kms_key" "encrypt_lambda_environments" {
  enable_key_rotation     = true
  description             = "Key to encrypt the Lambda environment variables in ${var.name}."
  deletion_window_in_days = 7
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias
resource "aws_kms_alias" "encrypt_lambda_environments" {
  name          = "alias/${var.name}-encrypt-lambda-environment"
  target_key_id = aws_kms_key.encrypt_lambda_environments.key_id
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
data "aws_iam_policy_document" "encrypt_lambda_environments_policy" {
  statement {
    sid       = "Enable IAM User Permissions"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["arn:aws:kms:${var.region}:${data.aws_caller_identity.current.account_id}:key/*"]
    principals {
      type        = "AWS"
      identifiers = [local.principal_root_arn]
    }
  }
  statement {
    sid    = "Allow Lambda to use the key"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
      "kms:CreateGrant"
    ]
    resources = [aws_kms_key.encrypt_lambda_environments.arn]
  }
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key_policy
resource "aws_kms_key_policy" "encrypt_lambda_environments" {
  key_id = aws_kms_key.encrypt_lambda_environments.id
  policy = data.aws_iam_policy_document.encrypt_lambda_environments_policy.json
}