resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

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

resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "${path.module}/files/hello.zip"
  function_name = "hello_world"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "hello.lambda_handler" #entry point to your lambda function

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  # source_code_hash, is used for updates, decides whether it needs to reupload the archive to the aws,
  #so the checksum will change and terraform knows that it should be reuploaded.
  #it#s basically the fingerprint of the file if one character changes in the file so does the fingerprint 
  # instead of using the filebase64sha256 we are going to reference the datasource we created
  source_code_hash = data.archive_file.lambda_deployment.output_base64sha256

  runtime = "python3.9"
}

#Automate creation of the zip file
data "archive_file" "lambda_deployment" {
  type        = "zip"
  source_file = "${path.module}/src/hello.py"
  output_path = "${path.module}/files/hello.zip"
}
