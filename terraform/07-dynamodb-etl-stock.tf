resource "aws_dynamodb_table" "etl-stock" {
  name           = "etl-stock"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "insert_datetime"
  range_key      = "stockname"

  attribute {
    name = "insert_datetime"
    type = "S"
  }

  attribute {
    name = "stockname"
    type = "S"
  }

  # Enable server-side encryption by default
  server_side_encryption {
    enabled = true
  }

  tags = {
    Name = "etl-stock"
  }
}

