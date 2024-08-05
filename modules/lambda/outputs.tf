output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.data_producer.arn
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.data_producer.function_name
}

output "lambda_role_arn" {
  description = "ARN of the IAM role for the Lambda function"
  value       = aws_iam_role.lambda_role.arn
}
