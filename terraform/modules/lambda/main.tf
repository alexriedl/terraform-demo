data "archive_file" "lambda" {
  type        = "zip"
  source_file = "../../../src/index.js"
  output_path = "lambda.zip"
}

resource "aws_lambda_function" "example_test_function" {
  filename         = "${data.archive_file.lambda.output_path}"
  function_name    = "TerraformDemo"
  role             = "${aws_iam_role.example_api_role.arn}"
  handler          = "index.handler"
  runtime          = "nodejs4.3"
  source_code_hash = "${base64sha256(file("${data.archive_file.lambda.output_path}"))}"
  publish          = true
}

resource "aws_iam_role" "example_api_role" {
  name = "example_api_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
