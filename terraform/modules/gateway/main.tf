resource "aws_api_gateway_rest_api" "example_api" {
  name        = "TerraformDemo"
  description = "Api Gateway Demo"
}

resource "aws_api_gateway_resource" "example_api_resource" {
  rest_api_id = "${aws_api_gateway_rest_api.example_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.example_api.root_resource_id}"
  path_part   = "messages"
}

resource "aws_api_gateway_method" "request_method" {
  rest_api_id   = "${aws_api_gateway_rest_api.example_api.id}"
  resource_id   = "${aws_api_gateway_resource.example_api_resource.id}"
  http_method   = "GET"
  authorization = "NONE"
}

data "aws_caller_identity" "current" {}

resource "aws_api_gateway_integration" "request_method_integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.example_api.id}"
  resource_id             = "${aws_api_gateway_resource.example_api_resource.id}"
  http_method             = "${aws_api_gateway_method.request_method.http_method}"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.region}:${data.aws_caller_identity.current.account_id}:function:${var.lambda_function_name}/invocations"
  integration_http_method = "POST"
}

resource "aws_api_gateway_method_response" "response_method" {
  rest_api_id = "${aws_api_gateway_rest_api.example_api.id}"
  resource_id = "${aws_api_gateway_resource.example_api_resource.id}"
  http_method = "${aws_api_gateway_integration.request_method_integration.http_method}"
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "response_method_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.example_api.id}"
  resource_id = "${aws_api_gateway_resource.example_api_resource.id}"
  http_method = "${aws_api_gateway_method_response.response_method.http_method}"
  status_code = "${aws_api_gateway_method_response.response_method.status_code}"

  response_templates = {
    "application/json" = ""
  }
}

resource "aws_lambda_permission" "allow_api_gateway" {
  function_name = "${var.lambda_function_name}"
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.example_api.id}/*/${aws_api_gateway_method.request_method.http_method}${aws_api_gateway_resource.example_api_resource.path}"
}

resource "aws_api_gateway_deployment" "example_deployment" {
  depends_on = [
    "aws_api_gateway_method.request_method",
    "aws_api_gateway_integration.request_method_integration",
    "aws_api_gateway_method_response.response_method",
    "aws_api_gateway_integration_response.response_method_integration",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.example_api.id}"
  stage_name  = "staging"
}
