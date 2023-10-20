# lambda layer (node_modules)
resource "aws_lambda_layer_version" "lambda_layer" {
  filename = data.archive_file.lambda_layer.output_path
  layer_name = "uuid"

  compatible_runtimes = ["nodejs18.x"]
}

# hello
resource "aws_lambda_function" "hello" {
  function_name = "hello"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key = aws_s3_object.lambda_hello.key

  runtime = "nodejs18.x"
  handler = "hello.handler"

  role = aws_iam_role.lambda_iam.arn
}

# users create
resource "aws_lambda_function" "users_create" {
  function_name = "users-create"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key = aws_s3_object.lambda_users_create.key
  
  runtime = "nodejs18.x"
  handler = "create.handler"
  timeout = 10

  role = aws_iam_role.lambda_iam.arn
  layers = [aws_lambda_layer_version.lambda_layer.arn]
}

# users findAll
resource "aws_lambda_function" "users_find_all" {
  function_name = "users-find-all"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key = aws_s3_object.lambda_users_find_all.key
  
  runtime = "nodejs18.x"
  handler = "findAll.handler"
  timeout = 10

  role = aws_iam_role.lambda_iam.arn
  layers = [aws_lambda_layer_version.lambda_layer.arn]
}

# users findById
resource "aws_lambda_function" "users_find_by_id" {
  function_name = "users-find-by-id"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key = aws_s3_object.lambda_users_find_by_id.key
  
  runtime = "nodejs18.x"
  handler = "findById.handler"
  timeout = 10

  role = aws_iam_role.lambda_iam.arn
  layers = [aws_lambda_layer_version.lambda_layer.arn]
}

resource "aws_cloudwatch_log_group" "cloud_watch" {
  name = "/aws/lambda/${aws_lambda_function.users_create.function_name}"
  retention_in_days = 30
}