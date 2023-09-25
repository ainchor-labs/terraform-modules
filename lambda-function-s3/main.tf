data "aws_s3_bucket_object" "existing" {
  bucket = "ainchor-news-lambda-code-bucket"
  key    = "${var.function_name}.zip"
}

resource "aws_lambda_function" "lambda_function" {
  environment {
    variables = var.env_vars
  }
  function_name    = "${var.product_name}-${var.function_name}"
  ephemeral_storage {
    size           = var.tmp_storage
  }
  handler          = "app.handler"
  role             = var.iam_role_arn
  memory_size      = var.memory
  runtime          = var.runtime
  timeout          = var.timeout
  s3_bucket        = "ainchor-news-lambda-code-bucket"
  s3_key           = "${var.function_name}.zip"
  s3_object_version = data.aws_s3_bucket_object.existing.version_id
}