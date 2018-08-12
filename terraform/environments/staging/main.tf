// CREDITS
// https://andydote.co.uk/2017/03/17/terraform-aws-lambda-api-gateway/

provider "aws" {
  region = "${var.region}"
}

variable "region" {
  default = "us-east-1"
}

module "lambda" {
  source = "../../modules/lambda"
}

module "gateway" {
  source = "../../modules/gateway"

  region               = "${var.region}"
  lambda_function_name = "${module.lambda.lambda_function_name}"
}
