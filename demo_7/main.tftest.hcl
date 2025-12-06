

run "valid_names" {

  command = plan

  module {
    source = "./module"
  }

  variables  {
  bucket_name  = "bucket-test"
  lambda_name  = "lambda-test"
  code_archive = "../../data/lambda.zip"
}


  assert {
    condition     = aws_s3_bucket.s3_module.bucket  == "bucket-test"
    error_message = "S3 bucket name did not match expected"
  }

  assert {
    condition     = aws_lambda_function.func.function_name == "lambda-test"
    error_message = "Lambda bucket name did not match expected"
  }

}