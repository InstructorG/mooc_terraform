output "output_buket_name" {
  value = aws_s3_bucket.s3_module.bucket
}

output "lambda_name" {
  value = aws_lambda_function.func.function_name
}