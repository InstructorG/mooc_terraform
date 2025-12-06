

run "valid_names" {


  #TODO : Preciser le commande

  #TODO : Preciser le module

  #TODO : Preciser les variables en input


  assert {
    condition     = aws_s3_bucket.s3_module.bucket  == "bucket-test"
    error_message = "S3 bucket name did not match expected"
  }

  assert {
    condition     = aws_lambda_function.func.function_name == "lambda-test"
    error_message = "Lambda bucket name did not match expected"
  }

}