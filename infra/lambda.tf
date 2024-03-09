resource "aws_lambda_function" "crc_lambda_func" {
    filename = data.archive_file.zip.output_path
    source_code_hash = data.archive_file.zip.output_base64sha256
    function_name = "crc_lambda_func"
    role = aws_iam_role.crc_lambda_iam.arn
    handler = "func.handler"
    runtime = "python3.12"
}

resource "aws_lambda_function_url" "crc_lambda_url"{
    function_name = aws_lambda_function.crc_lambda_func.function_name
    authorization_type = "NONE"

    cors {
        allow_credentials = true
        allow_origins = ["https://resume.robotra.sh"]
        allow_methods = ["*"]
        allow_headers = ["date","keep-alive"]
        expose_headers = ["keep-alive","date"]
        max_age = 86400
    }
}

resource "aws_iam_role" "crc_lambda_iam" {
    name = "crc_lambda_iam"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Sid = ""
                Principal = {
                    Service = "lambda.amazonaws.com"
                }
            },
        ]
    })

    tags = {
        project = "Cloud Resume Challenge"
    }
}

data "archive_file" "zip" {
    type = "zip"
    source_dir = "${path.module}/lambda/"
    output_path = "${path.module}/packedLambda.zip"
}