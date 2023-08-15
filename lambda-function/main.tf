provider "aws" { }

resource "aws_ecr_repository" "lambda_repository" {
  name = "lambda_repository"
}

resource "aws_lambda_function" "lambda_function" {
  environment {
    variables = var.env_vars
  }

  function_name   = "${var.product_name}-${var.function_name}"
  image_uri       = var.image_uri
  role            = var.iam_role_arn
  memory_size     = var.memory
  package_type    = "Image"
  timeout         = var.timeout
}