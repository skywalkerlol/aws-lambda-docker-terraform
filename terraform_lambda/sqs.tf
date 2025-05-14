# Dead Letter Queue for Lambda failures
resource "aws_sqs_queue" "dlq" {
  name              = "${var.function_name}-dlq"
  kms_master_key_id = aws_kms_key.lambda_key.id
}