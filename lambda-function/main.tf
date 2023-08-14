provider "aws" {
  region = "us-east-1"
}

resource "aws_ecr_repository" "lambda_repository" {
  name = "${var.product_name}/${var.function_name}-function-repo"
}

# Use the AWS CLI to authenticate Docker to your ECR registry
resource "null_resource" "docker_auth" {
  provisioner "local-exec" {
    command = "aws ecr get-login-password --region ${aws_ecr_repository.lambda_repository.region} | docker login --username AWS --password-stdin ${aws_ecr_repository.lambda_repository.repository_url}"
  }
}

# Push the Docker image to the ECR repository
resource "null_resource" "push_to_ecr" {
  depends_on = [
    null_resource.docker_auth,
    aws_ecr_repository.lambda_repository
  ]
  
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "docker tag your-app-image:latest ${aws_ecr_repository.lambda_repository.repository_url}:latest && docker push ${aws_ecr_repository.lambda_repository.repository_url}:latest"
  }
}

resource "aws_lambda_function" "lambda_function" {
  depends_on = [
    aws_ecr_repository.lambda_repository,
    aws.null_resource.push_to_ecr
  ]
  environment {
    variables = var.env_vars
  }

  # ephemeral_storage {
  #   size = var.tmp_storage
  # }

  function_name   = "${var.product_name}-${var.function_name}"
  role            = var.iam_role_arn
  memory_size     = var.memory
  package_type    = "Image"
  timeout         = var.timeout
  image_uri       = "${aws_ecr_repository.lambda_repository.repository_url}:latest"
}