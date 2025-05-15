# Dead Letter Queue for Lambda failures
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue
resource "aws_sqs_queue" "lambda_dead_letter_queue" {
  name              = "${var.name}-dead-letter-queue"
  kms_master_key_id = aws_kms_key.encrypt_sqs.id
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key
resource "aws_kms_key" "encrypt_sqs" {
  enable_key_rotation     = true
  description             = "Key to encrypt the SQS queue in ${var.name}."
  deletion_window_in_days = 7
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias
resource "aws_kms_alias" "encrypt_sqs" {
  name          = "alias/${var.name}-encrypt-sqs"
  target_key_id = aws_kms_key.encrypt_sqs.key_id
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
data "aws_iam_policy_document" "encrypt_sqs_policy" {
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
    sid    = "Allow SQS to use the key"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["sqs.amazonaws.com"]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
      "kms:CreateGrant"
    ]
    resources = [aws_kms_key.encrypt_sqs.arn]
  }
}
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key_policy
resource "aws_kms_key_policy" "encrypt_sqs" {
  key_id = aws_kms_key.encrypt_sqs.id
  policy = data.aws_iam_policy_document.encrypt_sqs_policy.json
}