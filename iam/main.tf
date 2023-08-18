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
                Service = "${var.assume_role}.amazonaws.com"
            }
        }]}
    )
}

resource "aws_iam_policy" "policy" {
  for_each = var.access_policies

  name   = "${var.name}-${each.key}-policy"
  policy = file("${path.module}/policies/${each.key}/${each.value}.json")
}


resource "aws_iam_policy_attachment" "policy_attachments" {
  for_each = var.access_policies

  name       = "${each.key}-attachment"
  policy_arn = aws_iam_policy.each.key_policy.arn
  roles      = [aws_iam_role.iam_role.name]
}
