provider "github" {

}

provider "aws" {
  region = "us-east-1"
}

# Create ECR Repo
resource "aws_ecr_repository" "lambda_repository" {
  name = "${var.product_name}/${var.function_name}-function-repo"
}

# Pull Docker image
resource "git_repository" "docker_repo" {
  clone_url = "https://github.com/ainchor-labs/ainchor-news.git"
}

# Create Docker Image
resource "null_resource" "docker_build" {
  triggers = {
    repository = git_repository.docker_repo.clone_url
  }

  depends_on = [git_repository.docker_repo]

  provisioner "local-exec" {
    command = "docker build -t my-docker-image -f ${git_repository.docker_repo.local_path}/${var.function-name}/Dockerfile ${git_repository.docker_repo.local_path}/${var.function-name}"
  }
}


# Use the AWS CLI to authenticate Docker to your ECR registry
resource "null_resource" "docker_auth" {
  provisioner "local-exec" {
    command = "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${aws_ecr_repository.lambda_repository.repository_url}"
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
    command = "docker tag ${git_repository.docker_repo.local_path}/${var.function-name}:latest ${aws_ecr_repository.lambda_repository.repository_url}:latest && docker push ${aws_ecr_repository.lambda_repository.repository_url}:latest"
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