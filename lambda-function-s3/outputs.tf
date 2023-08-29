output "lambda_function_arn" {
  description = "The ARN of the deployed Lambda function."
  value       = aws_lambda_function.lambda_function.arn
}