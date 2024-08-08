resource "aws_lambda_function" "data_producer" {
  filename         = "${path.module}/lambda_function.zip"
  function_name    = "${var.prefix}-stock-market-data-producer"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  timeout          = 300
  memory_size      = 256

  environment {
    variables = {
      KAFKA_BOOTSTRAP_SERVERS = var.kafka_bootstrap_servers
      KAFKA_TOPIC             = var.kafka_topic_name
      API_ENDPOINT            = var.stock_market_api_endpoint
    }
  }

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [var.lambda_security_group_id]
  }

  tags = {
    Name        = "${var.prefix}-stock-market-data-producer"
    Environment = var.environment
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "${var.prefix}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_msk_access" {
  name = "${var.prefix}-lambda-msk-access"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kafka:DescribeCluster",
          "kafka:GetBootstrapBrokers",
          "kafka:ListTopics"
        ]
        Effect   = "Allow"
        Resource = var.msk_cluster_arn
      },
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_cloudwatch_event_rule" "data_producer_trigger" {
  name                = "${var.prefix}-data-producer-trigger"
  description         = "Trigger the data producer Lambda function"
  schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "data_producer_lambda_target" {
  rule      = aws_cloudwatch_event_rule.data_producer_trigger.name
  target_id = "DataProducerLambda"
  arn       = aws_lambda_function.data_producer.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.data_producer.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.data_producer_trigger.arn
}

# Add this resource to the existing lambda/main.tf file

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

resource "aws_iam_role_policy" "lambda_msk_full_access" {
  name = "${var.prefix}-lambda-msk-full-access"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kafka:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_vpc_access" {
  name = "${var.prefix}-lambda-vpc-access"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}
