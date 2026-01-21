resource "aws_iam_role" "test_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

}

resource "aws_iam_role_policy_attachment" "name" {
    role = aws_iam_role.test_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  
}

resource "aws_lambda_function" "name" {
    function_name = "lambda_function"
    role = aws_iam_role.test_role.arn
    handler = "lambda_function.lambda_handler"
    runtime = "python3.12"
    timeout = 900
    memory_size = 128
    filename = "lambda_function.zip"

    source_code_hash = filebase64sha256("lambda_function.zip")
  
}

resource "aws_cloudwatch_event_rule" "for_every_five_minutes" {
    name = "for_every_five_minutes"
    description = "trigger_lambda_for_every_five_minutes"
    schedule_expression = "cron(0/5 * * * ? *)"
  
}

resource "aws_cloudwatch_event_target" "invoke_lambda" {
    rule = aws_cloudwatch_event_rule.for_every_five_minutes.name
    target_id = "lambda"
    arn = aws_lambda_function.name.arn
  
}

resource "aws_lambda_permission" "name" {
    statement_id = "AllowExecutionFromEventBridge"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.name.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.for_every_five_minutes.arn

  
}
