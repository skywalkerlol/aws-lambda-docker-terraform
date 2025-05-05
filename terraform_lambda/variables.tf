variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "image_uri" {
  description = "ECR Image URI for the Lambda container image (format: {account}.dkr.ecr.{region}.amazonaws.com/{repo}:{tag})"
  type        = string
}

variable "memory_size" {
  description = "Memory size for the Lambda function (in MB)"
  type        = number
  default     = 128
}

variable "timeout" {
  description = "Timeout for the Lambda function (in seconds)"
  type        = number
  default     = 30
}

variable "environment_variables" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "log_retention_days" {
  description = "Number of days to retain Lambda logs"
  type        = number
  default     = 14
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "create_function_url" {
  description = "Whether to create a function URL for the Lambda"
  type        = bool
  default     = false
}

variable "subnet_ids" {
  description = "List of subnet IDs for Lambda VPC configuration"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "List of security group IDs for Lambda VPC configuration"
  type        = list(string)
  default     = []
}

variable "reserved_concurrency" {
  description = "Reserved concurrent executions for the Lambda function"
  type        = number
  default     = 100
}