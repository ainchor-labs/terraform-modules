provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "iam_role" {
    name = "${var.product}_${var.name}"
    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [{
            Action = "sts:AssumeRole",
            Effect = "Allow",
            Principal = {
                Service = "${var.assume}.amazonaws.com"
            }
        }]}
    )
}

resource "aws_iam_policy" "policy" {
  for_each = var.access_policies

  name   = "${var.name}-${each.key}-policy"  # Use var.name instead of var.role_name
  policy = file("${path.module}/policies/${each.key}/${each.value}.json")
}

resource "aws_iam_policy_attachment" "policy_attachments" {
  for_each = aws_iam_policy.policy  # Use the correct reference

  name       = "${each.key}-attachment"
  policy_arn = each.value.arn  # Use each.value.arn to access the ARN of the policy
  roles      = [aws_iam_role.iam_role.name]
}
