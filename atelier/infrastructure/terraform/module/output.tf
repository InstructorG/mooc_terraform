output "api_url" {
  value = "${aws_api_gateway_deployment.api_deployment.invoke_url}${aws_api_gateway_stage.prod.stage_name}/proverb"
}
