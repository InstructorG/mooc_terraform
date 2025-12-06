locals {
  component_name = "<changer-le-nom>-${random_string.random.result}"
}

resource "random_string" "random" {
  special = false
  length  = 10
  upper   = false
}

#---------------------------------------------- S3

#TODO : Créer un Bucket S3 pour héberger le front en mode site statique
# ...

#TODO : Rattacher au bucket s3
resource "aws_s3_bucket_website_configuration" "front_bucket_website" {
  bucket = # ...

  index_document {
    suffix = "index.html"
  }
  depends_on = [aws_s3_bucket_public_access_block.front_bucket_block]
}

#TODO : Rattacher au bucket s3
resource "aws_s3_bucket_public_access_block" "front_bucket_block" {
  bucket = # ...

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#TODO : Rattacher au bucket s3
resource "aws_s3_bucket_policy" "front_bucket_policy" {
  bucket = # ...
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid       = "PublicReadGetObject",
      Effect    = "Allow",
      Principal = "*",
      Action    = "s3:*",
      Resource  = "${aws_s3_bucket#...}/*"
    }]
  })
}

# TODO:  Upload du fichier index.html dans le bucket S3
resource "aws_s3_object" "front_index" {
  bucket       = # ...
  key          = # ...
  source       = "../../build/front_extracted/index.html"
  content_type = # ...
  etag         = filemd5("../../build/front_extracted/index.html")
}

# TODO:  Upload du fichier script.js dans le bucket S3
resource "aws_s3_object" "script" {
  bucket       = # ...
  key          = # ...
  source       = "../../build/front_extracted/script.js"
  content_type = # ...
  etag         = filemd5("../../build/front_extracted/script.js")
}

# TODO:  Upload du fichier style.css dans le bucket S3
resource "aws_s3_object" "style" {
  bucket       = # ...
  key          = # ...
  source       = "../../build/front_extracted/style.css"
  content_type = # ...
  etag         = filemd5("../../build/front_extracted/style.css")
}

#---------------------------------------------- Lambda

# TODO:  créer une lambda
# ...

# Rôle IAM pour la fonction Lambda
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"
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
# ...


