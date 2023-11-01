# users table
resource "aws_dynamodb_table" "wonder_user" {
  name = "wonder_user"
  billing_mode = "PROVISIONED"
  hash_key = "username"
  read_capacity  = 10
  write_capacity = 10

  attribute {
    name = "username"
    type = "S"
  }
}

# requests table
resource "aws_dynamodb_table" "wonder_request" {
  name = "wonder_request"
  billing_mode = "PROVISIONED"
  hash_key = "id"
  read_capacity  = 10
  write_capacity = 10

  attribute {
    name = "id"
    type = "S"
  }
}