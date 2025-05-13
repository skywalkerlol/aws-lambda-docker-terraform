terraform {
  backend "s3" {
    bucket       = "kunduso-terraform-remote-bucket"
    encrypt      = true
    key          = "tf/aws-lambda-docker-terraform/terraform_lambda/terraform.tfstate"
    region       = "us-east-2"
    use_lockfile = true
  }
}