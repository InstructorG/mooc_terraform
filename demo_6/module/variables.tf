variable "bucket_name" {
  description = "(Required) Bucket name where data is received"
  type = string
}

variable "lambda_name" {
  description = "(Required) Lambda name where data is processed"
  type = string
}


variable "code_archive" {
  description = "(Required) lambda code to deploy"
  type = string
}