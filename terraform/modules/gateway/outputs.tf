output "api_url" {
  value = "https://${aws_api_gateway_deployment.example_deployment.rest_api_id}.execute-api.${var.region}.amazonaws.com/${aws_api_gateway_deployment.example_deployment.stage_name}"
}
