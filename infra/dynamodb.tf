resource "aws_dynamodb_table" "crc_viewcount_db" {
  name           = "crc-viewcount-db"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    project = "Cloud Resume Project"
  }
}

resource "aws_dynamodb_table_item" "crc_viewcount_item" {
  table_name = aws_dynamodb_table.crc_viewcount_db.name
  hash_key = aws_dynamodb_table.crc_viewcount_db.hash_key

  item = <<ITEM
  {
    "id": {"S": "1"},
    "views": { "N": "23"}
  }
  ITEM
}