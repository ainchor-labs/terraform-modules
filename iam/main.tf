provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "iam_role" {
    name = var.name
    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [{
            Action = "sts:AssumeRole",
            Effect = "Allow",
            Principal = {
                Service = "${vars.assume_role}.amazonaws.com"
            }
        }]}
    )
}

foreach var.access_policies as key, value {
  resource "aws_iam_policy" "${key}_policy" {
    name   = "${var.role_name}-${key}-policy"
    policy = file("${path.module}/policies/${key}/${value}.json")
  }
}

foreach var.access_policies as key, value {
  resource "aws_iam_policy_attachment" "${key}_attachment" {
    policy_arn = aws_iam_policy.${key}_policy.arn
    roles      = [aws_iam_role.role.name]
  }
}