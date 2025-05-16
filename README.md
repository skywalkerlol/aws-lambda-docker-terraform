[![License: Unlicense](https://img.shields.io/badge/license-Unlicense-white.svg)](https://choosealicense.com/licenses/unlicense/) [![GitHub pull-requests closed](https://img.shields.io/github/issues-pr-closed/kunduso/aws-lambda-docker-terraform)](https://github.com/kunduso/aws-lambda-docker-terraform/pulls?q=is%3Apr+is%3Aclosed) [![GitHub pull-requests](https://img.shields.io/github/issues-pr/kunduso/aws-lambda-docker-terraform)](https://GitHub.com/kunduso/aws-lambda-docker-terraform/pull/) 
[![GitHub issues-closed](https://img.shields.io/github/issues-closed/kunduso/aws-lambda-docker-terraform)](https://github.com/kunduso/aws-lambda-docker-terraform/issues?q=is%3Aissue+is%3Aclosed) [![GitHub issues](https://img.shields.io/github/issues/kunduso/aws-lambda-docker-terraform)](https://GitHub.com/kunduso/aws-lambda-docker-terraform/issues/) 
[![terraform-infra-provisioning](https://github.com/kunduso/aws-lambda-docker-terraform/actions/workflows/terraform.yml/badge.svg?branch=main)](https://github.com/kunduso/aws-lambda-docker-terraform/actions/workflows/terraform.yml) [![checkov-scan](https://github.com/kunduso/aws-lambda-docker-terraform/actions/workflows/code-scan.yml/badge.svg?branch=main)](https://github.com/kunduso/aws-lambda-docker-terraform/actions/workflows/code-scan.yml) 

## Introduction
This repository demonstrates how to deploy a containerized Lambda function using Terraform and GitHub Actions. It showcases a complete CI/CD pipeline that:

1. Creates an Amazon ECR repository with encryption
2. Builds a Docker image, scans it for vulnerabilities, and pushes it to ECR
3. Deploys an AWS Lambda function using the Docker container image

The workflow is designed to be secure, efficient, and follows infrastructure-as-code best practices.

## Deployment Process
The GitHub Actions workflow consists of three main jobs:

1. **ECR Creation (`ecr_create`)**: 
   - Provisions an Amazon ECR repository using Terraform in the `terraform_ecr` folder
   - Sets up repository encryption
   - Outputs the repository URL and name for subsequent jobs

2. **Docker Build and Push (`docker_build_push`)**:
   - Builds a Docker image from the `Dockerfile` in the `lambda_src` folder
   - Scans the image for vulnerabilities using Trivy
   - Pushes the image to ECR (only on `main` branch)
   - Passes the image URI and tag to the next job

3. **Lambda Deployment (`deploy_lambda`)**:
   - Deploys an AWS Lambda function using Terraform code in the `terraform_lambda` folder
   - Configures the Lambda to use the Docker image from ECR
   - Sets up necessary IAM roles and permissions for the Lambda to use

The pipeline includes conditional logic to ensure that:
- Docker images are only pushed to ECR on the `main` branch
- Infrastructure changes are applied only on the `main` branch
- Pull requests receive cost estimates via Infracost
- Security scanning is performed on all builds

## Prerequisites
For this code to function without errors, an OpenID Connect identity provider needs to be created in Amazon Identity and Access Management that has a trust relationship with this GitHub repository. You can read about it [here](https://skundunotes.com/2023/02/28/securely-integrate-aws-credentials-with-github-actions-using-openid-connect/) to get a detailed explanation with steps.
<br />The `ARN` of the `IAM Role` should be stored as a GitHub secret which is referred to in the [`terraform.yml`](./.github/workflows/terraform.yml) file.

<br />For Infracost integration in this repository, the `INFRACOST_API_KEY` needs to be stored as a repository secret. It is referenced in the [`terraform.yml`](./.github/workflows/terraform.yml) GitHub actions workflow file.
<br />Additionally, the cost estimate process is managed using a GitHub Actions variable `INFRACOST_SCAN_TYPE` where the value is either `hcl_code` or `tf_plan`, depending on the type of scan desired.
<br />You can read about that at - [integrate-Infracost-with-GitHub-Actions.](http://skundunotes.com/2023/07/17/estimate-aws-cloud-resource-cost-with-infracost-terraform-and-github-actions/)

## Usage
Ensure that the policy attached to the IAM role whose credentials are being used in this configuration has permission to create and manage all the resources that are included in this repository, including ECR repositories, Lambda functions, and IAM roles.
<br />
<br />Review the code, including the [`terraform.yml`](./.github/workflows/terraform.yml) to understand the steps in the GitHub Actions pipeline. The repository is organized into three main components:
- `terraform_ecr/`: Terraform code for creating the ECR repository
- `lambda_src/`: Source code for the Lambda function and Dockerfile
- `terraform_lambda/`: Terraform code for deploying the Lambda function
<br />To check the pipeline logs, click on the **Build Badge** (terraform-infra-provisioning) above the image in this ReadMe.

## Contributing
If you find any issues or have suggestions for improvement, feel free to open an issue or submit a pull request. Contributions are always welcome!

## License
This code is released under the Unlincse License. See [LICENSE](LICENSE).
