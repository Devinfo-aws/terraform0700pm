resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "rajrajrajrajrajraj"
  
}
#upload zip file to s3

resource "aws_s3_object" "lambda_zipfile" {
bucket = aws_s3_bucket.lambda_bucket.id
key = "lambda/lambda_function.zip"
source = "lambda_function.zip"
etag   = filemd5("lambda_function.zip")
  
}


resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_role" {
  role = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  
}

resource "aws_iam_role_policy_attachment" "s3_read" {
  role = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"

  
}

resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda_function"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"

  timeout     = 900
  memory_size = 128

  # 🔑 Code pulled from S3 (NOT local)
  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_zipfile.key

  source_code_hash = filebase64sha256("lambda_function.zip")
}