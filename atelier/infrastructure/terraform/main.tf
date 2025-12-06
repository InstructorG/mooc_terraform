locals {
  component_name = "demo-terraform-atelier-${random_string.random.result}"
}

resource "random_string" "random" {
  special = false
  length  = 10
  upper   = false
}

#---------------------------------------------- S3

#TODO : Créer un Bucket S3 pour héberger le front en mode site statique
resource "aws_s3_bucket" "front_bucket" {
  bucket = "s3-${local.component_name}"

  force_destroy = true# nom unique
}

#TODO : Rattacher au bucket s3
resource "aws_s3_bucket_website_configuration" "front_bucket_website" {
  bucket = aws_s3_bucket.front_bucket.id

  index_document {
    suffix = "index.html"
  }
  depends_on = [aws_s3_bucket_public_access_block.front_bucket_block]
}

#TODO : Rattacher au bucket s3
resource "aws_s3_bucket_public_access_block" "front_bucket_block" {
  bucket = aws_s3_bucket.front_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#TODO : Rattacher au bucket s3
resource "aws_s3_bucket_policy" "front_bucket_policy" {
  bucket = aws_s3_bucket.front_bucket.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid       = "PublicReadGetObject",
      Effect    = "Allow",
      Principal = "*",
      Action    = "s3:*",
      Resource  = "${aws_s3_bucket.front_bucket.arn}/*"
    }]
  })
}

# TODO:  Upload du fichier index.html dans le bucket S3
resource "aws_s3_object" "front_index" {
  bucket       = aws_s3_bucket.front_bucket.bucket
  key          = "index.html"
  source       = "../../build/front_extracted/index.html"
  content_type = "text/html"
  etag         = filemd5("../../build/front_extracted/index.html")
}

# TODO:  Upload du fichier script.js dans le bucket S3
resource "aws_s3_object" "script" {
  bucket       = aws_s3_bucket.front_bucket.bucket
  key          = "script.js"
  source       = "../../build/front_extracted/script.js"
  content_type = "application/javascript"
  etag         = filemd5("../../build/front_extracted/script.js")
}

# TODO:  Upload du fichier style.css dans le bucket S3
resource "aws_s3_object" "style" {
  bucket       = aws_s3_bucket.front_bucket.bucket
  key          = "style.css"
  source       = "../../build/front_extracted/style.css"
  content_type = "text/css"
  etag         = filemd5("../../build/front_extracted/style.css")
}

#---------------------------------------------- Lambda

# TODO:  créer une lambda
resource "aws_lambda_function" "proverb_lambda" {
  function_name    = "lambda-${local.component_name}"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"
  filename         = "../../build/backend-${var.version_backend}.zip"
  source_code_hash = filebase64sha256("../../build/backend-${var.version_backend}.zip")
}

# Rôle IAM pour la fonction Lambda
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role-${local.component_name}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Effect = "Allow",
      Sid    = ""
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}



#---------------------------------------------- API Gateway

# TODO: Appeler le module api gateway
module "api_gateway" {
  source                     = "./module"
  api_gateway_name           = "apitgwy-${local.component_name}"
  lambda_function_invoke_arn = aws_lambda_function.proverb_lambda.invoke_arn
  lambda_function_name       = aws_lambda_function.proverb_lambda.function_name
}

