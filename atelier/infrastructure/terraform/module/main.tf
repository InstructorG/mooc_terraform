
# API Gateway pour exposer la Lambda
resource "aws_api_gateway_rest_api" "proverb_api" {
  name = var.api_gateway_name
}

resource "aws_api_gateway_resource" "proverb_resource" {
  rest_api_id = aws_api_gateway_rest_api.proverb_api.id
  parent_id   = aws_api_gateway_rest_api.proverb_api.root_resource_id
  path_part   = "proverb"
}

resource "aws_api_gateway_method" "get_method" {
  rest_api_id   = aws_api_gateway_rest_api.proverb_api.id
  resource_id   = aws_api_gateway_resource.proverb_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.proverb_api.id
  resource_id             = aws_api_gateway_resource.proverb_resource.id
  http_method             = aws_api_gateway_method.get_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_function_invoke_arn
}


# Permission pour API Gateway d'invoquer la Lambda
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.proverb_api.execution_arn}/*/*"
}

# Déploiement de l'API Gateway
resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on  = [aws_api_gateway_integration.lambda_integration]
  rest_api_id = aws_api_gateway_rest_api.proverb_api.id
  description = "Deployment of the API"
}

# Création du stage 'prod' associé au déploiement
resource "aws_api_gateway_stage" "prod" {
  stage_name    = var.stage_name
  rest_api_id   = aws_api_gateway_rest_api.proverb_api.id
  deployment_id = aws_api_gateway_deployment.api_deployment.id
}