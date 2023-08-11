provider "aws" {
  region = "us-east-1"
}

resource "aws_ecr_repository" "lambda_repository" {
  name = "${var.product_name}/${var.function_name}"
}

resource "aws_lambda_function" "lambda_function" {
  function_name   = var.function_name
  role            = var.iam_role_arn
  handler         = var.handler
  memory_size     = var.memory
  package_type    = "Image"
  timeout         = var.timeout
  image_uri       = "${aws_ecr_repository.lambda_repository.repository_url}:latest"
}

output "lambda_function_arn" {
  value = aws_lambda_function.lambda_function.arn
}