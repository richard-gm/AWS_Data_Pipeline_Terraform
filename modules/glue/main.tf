resource "aws_glue_catalog_database" "stock_market_db" {
  name = "${var.prefix}_stock_market_db"
}

resource "aws_glue_crawler" "stock_market_crawler" {
  name          = "${var.prefix}_stock_market_crawler"
  database_name = aws_glue_catalog_database.stock_market_db.name
  role          = aws_iam_role.glue_role.arn

  s3_target {
    path = "s3://${var.s3_bucket_name}/stock-market-data/"
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_iam_role" "glue_role" {
  name = "${var.prefix}_glue_crawler_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "glue_service" {
  role       = aws_iam_role.glue_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}
