provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "iam_role" {
    name = var.name
    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
        {
            Action = "sts:AssumeRole",
            Effect = "Allow",
            Principal = {
            Service = "${vars.assume_role}.amazonaws.com"
            }
        }
        ]
    })
}