resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:ap-southeast-1:*:*"
        Effect   = "Allow"
      },
    ]
  })
}

resource "aws_lambda_function" "extract_func" {
  function_name = "extract_func"

  runtime = "python3.9"
  handler = "lambda_function.lambda_handler"

  role             = aws_iam_role.lambda_role.arn
  timeout          = 15
  layers           = ["arn:aws:lambda:ap-southeast-1:937748925159:layer:senior-project-etl-layer:6"]
  filename         = "insert-crypto-data-daily.zip"
  source_code_hash = filebase64sha256("insert-crypto-data-daily.zip")

  environment {
    variables = {
      DATABASE_USERNAME = var.db_username,
      DATABASE_PASSWORD = var.db_password,
      DATABASE_URL      = var.db_url,
      DATABASE_NAME     = var.db_name,
    }
  }
}

resource "aws_cloudwatch_event_rule" "scheduled_rule" {
  for_each            = var.cron_lambda_schedules
  name                = "${each.key}-trigger"
  description         = "Triggers every day at ${each.key}"
  schedule_expression = each.value
}

resource "aws_cloudwatch_event_target" "event_target" {
  for_each = var.cron_lambda_schedules
  rule     = aws_cloudwatch_event_rule.scheduled_rule[each.key].name
  arn      = aws_lambda_function.extract_func.arn

  input = jsonencode({
    time = each.key
  })
}

resource "aws_lambda_permission" "eventbridge_permission" {
  for_each      = var.cron_lambda_schedules
  statement_id  = "AllowExecutionFromEventBridge_${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.extract_func.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.scheduled_rule[each.key].arn
}


# resource "aws_cloudwatch_event_rule" "twelve_test_event_rule" {
#   name                = "twelve_test_event_rule"
#   description         = "Triggers on a schedule 1200 +0"
#   schedule_expression = "cron(9 4 * * ? *)"
# }

# resource "aws_cloudwatch_event_target" "my_event_target" {
#   rule      = aws_cloudwatch_event_rule.twelve_test_event_rule.name
#   arn       = aws_lambda_function.extract_func.arn

#   input = jsonencode({
#     key1 = "value1"
#     key2 = "value2"
#   })
# }

# resource "aws_lambda_permission" "allow_cloudwatch_to_call_twelve" {
#   statement_id  = "AllowExecutionFromCloudWatch"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.extract_func.function_name
#   principal     = "events.amazonaws.com"
#   source_arn    = aws_cloudwatch_event_rule.twelve_test_event_rule.arn
# }

