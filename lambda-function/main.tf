provider "aws" {
  region = "us-east-1"
}

# Create ECR Repo
resource "aws_ecr_repository" "lambda_repository" {
  name = "${var.product_name}/${var.function_name}-function-repo"
}

resource "aws_lambda_function" "lambda_function" {
  depends_on = [
    aws_ecr_repository.lambda_repository
  ]
  environment {
    variables = var.env_vars
  }


  function_name   = "${var.product_name}-${var.function_name}"
  role            = var.iam_role_arn
  memory_size     = var.memory
  package_type    = "Image"
  timeout         = var.timeout
  image_uri       = "${aws_ecr_repository.lambda_repository.repository_url}:latest"
}