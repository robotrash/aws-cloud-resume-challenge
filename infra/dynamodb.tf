resource "aws_dynamodb_table" "crc_viewcount_db" {
  name           = "crc-viewcount-db"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "Id"

  attribute {
    name = "Id"
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
    "Id": {"S": "ViewCount"},
    "views": { "N": "23"}
  }
  ITEM
}