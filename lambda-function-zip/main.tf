resource "aws_lambda_function" "lambda_function" {
  environment {
    variables = var.env_vars
  }
  filename         = var.filename
  function_name    = "${var.product_name}-${var.function_name}"
  handler          = "app.handler"
  role             = var.iam_role_arn
  memory_size      = var.memory
  runtime          = var.runtime
  timeout          = var.timeout
  source_code_hash = base64sha256(filebase64(var.filename))
}