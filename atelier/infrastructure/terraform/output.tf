# Output de l'URL de l'API
output "api_url" {
  value = module.api_gateway.api_url
}

# TODO: Changer avec le nom du bucket
output "s3_url" {
  value = "https://${aws_s3_bucket.front_bucket.bucket}.s3.eu-west-3.amazonaws.com/index.html"
}