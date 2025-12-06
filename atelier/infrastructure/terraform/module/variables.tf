variable "lambda_function_name" {
  type = string
}

variable "lambda_function_invoke_arn" {
  type = string
}

variable "api_gateway_name" {
  type = string
}

variable "stage_name" {
  default = "prod"
  type = string
}