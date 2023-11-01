resource "aws_apigatewayv2_api" "api_gateway" {
  name = "wonder-lambda"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "api_gateway" {
  api_id = aws_apigatewayv2_api.api_gateway.id

  name = "wonder-lambda-stage"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.cloud_watch.arn

    format = jsonencode({
      requestId = "$context.requestId"
      sourceIp = "$context.identity.sourceIp"
      requestTime = "$context.requestTime"
      protocol = "$context.protocol"
      httpMethod = "$context.httpMethod"
      resourcePath = "$context.resourcePath"
      routeKey = "$context.routeKey"
      status = "$context.status"
      responseLength = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
    })
  }
}

# [GET] /hello
resource "aws_apigatewayv2_integration" "hello" {
  api_id = aws_apigatewayv2_api.api_gateway.id

  integration_uri = aws_lambda_function.hello.invoke_arn
  integration_type = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "hello" {
  api_id = aws_apigatewayv2_api.api_gateway.id

  route_key = "GET /hello"
  target = "integrations/${aws_apigatewayv2_integration.hello.id}"
}

resource "aws_lambda_permission" "api_gw_hello" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.api_gateway.execution_arn}/*/*"
}

# [POST] /users
resource "aws_apigatewayv2_integration" "users_create" {
  api_id = aws_apigatewayv2_api.api_gateway.id

  integration_uri = aws_lambda_function.users_create.invoke_arn
  integration_type = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "users_create" {
  api_id = aws_apigatewayv2_api.api_gateway.id

  route_key = "POST /users"
  target = "integrations/${aws_apigatewayv2_integration.users_create.id}"
}

resource "aws_lambda_permission" "api_gw_users_create" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.users_create.function_name
  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.api_gateway.execution_arn}/*/*"
}

# [GET] /users
resource "aws_apigatewayv2_integration" "users_find_all" {
  api_id = aws_apigatewayv2_api.api_gateway.id

  integration_uri = aws_lambda_function.users_find_all.invoke_arn
  integration_type = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "users_find_all" {
  api_id = aws_apigatewayv2_api.api_gateway.id

  route_key = "GET /users"
  target = "integrations/${aws_apigatewayv2_integration.users_find_all.id}"
}

resource "aws_lambda_permission" "awi_gw_users_find_all" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.users_find_all.function_name
  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.api_gateway.execution_arn}/*/*"
}

# [GET] /users/:username
resource "aws_apigatewayv2_integration" "users_find_by_id" {
  api_id = aws_apigatewayv2_api.api_gateway.id

  integration_uri = aws_lambda_function.users_find_by_id.invoke_arn
  integration_type = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "users_find_by_id" {
  api_id = aws_apigatewayv2_api.api_gateway.id

  route_key = "GET /users/{username}"
  target = "integrations/${aws_apigatewayv2_integration.users_find_by_id.id}"
}

resource "aws_lambda_permission" "awi_gw_users_find_by_id" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.users_find_by_id.function_name
  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.api_gateway.execution_arn}/*/*"
}

# [POST] /auth/by-pass
resource "aws_apigatewayv2_integration" "auth_by_pass" {
  api_id = aws_apigatewayv2_api.api_gateway.id

  integration_uri = aws_lambda_function.auth_by_pass.invoke_arn
  integration_type = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "auth_by_pass" {
  api_id = aws_apigatewayv2_api.api_gateway.id

  route_key = "POST /auth/by-pass"
  target = "integrations/${aws_apigatewayv2_integration.auth_by_pass.id}"
}

resource "aws_lambda_permission" "awi_gw_auth_by_pass" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.auth_by_pass.function_name
  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.api_gateway.execution_arn}/*/*"
}

# [POST] /auth/verify
resource "aws_apigatewayv2_integration" "auth_verify" {
  api_id = aws_apigatewayv2_api.api_gateway.id

  integration_uri = aws_lambda_function.auth_verify.invoke_arn
  integration_type = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "auth_verify" {
  api_id = aws_apigatewayv2_api.api_gateway.id

  route_key = "POST /auth/verify"
  target = "integrations/${aws_apigatewayv2_integration.auth_verify.id}"
}

resource "aws_lambda_permission" "awi_gw_auth_verify" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.auth_verify.function_name
  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.api_gateway.execution_arn}/*/*"
}

# [POST] /request
resource "aws_apigatewayv2_integration" "request_create" {
  api_id = aws_apigatewayv2_api.api_gateway.id

  integration_uri = aws_lambda_function.request_create.invoke_arn
  integration_type = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "request_create" {
  api_id = aws_apigatewayv2_api.api_gateway.id

  route_key = "POST /request"
  target = "integrations/${aws_apigatewayv2_integration.request_create.id}"
}

resource "aws_lambda_permission" "api_gw_request_create" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.request_create.function_name
  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.api_gateway.execution_arn}/*/*"
}

# [GET] /request
resource "aws_apigatewayv2_integration" "request_find_all" {
  api_id = aws_apigatewayv2_api.api_gateway.id

  integration_uri = aws_lambda_function.request_find_all.invoke_arn
  integration_type = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "request_find_all" {
  api_id = aws_apigatewayv2_api.api_gateway.id

  route_key = "GET /request"
  target = "integrations/${aws_apigatewayv2_integration.request_find_all.id}"
}

resource "aws_lambda_permission" "awi_gw_request_find_all" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.request_find_all.function_name
  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.api_gateway.execution_arn}/*/*"
}

# [GET] /request/:id
resource "aws_apigatewayv2_integration" "request_find_by_id" {
  api_id = aws_apigatewayv2_api.api_gateway.id

  integration_uri = aws_lambda_function.request_find_by_id.invoke_arn
  integration_type = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "request_find_by_id" {
  api_id = aws_apigatewayv2_api.api_gateway.id

  route_key = "GET /request/{id}"
  target = "integrations/${aws_apigatewayv2_integration.request_find_by_id.id}"
}

resource "aws_lambda_permission" "awi_gw_request_find_by_id" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.request_find_by_id.function_name
  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.api_gateway.execution_arn}/*/*"
}

# [PATCH] /request
resource "aws_apigatewayv2_integration" "request_update" {
  api_id = aws_apigatewayv2_api.api_gateway.id

  integration_uri = aws_lambda_function.request_update.invoke_arn
  integration_type = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "request_update" {
  api_id = aws_apigatewayv2_api.api_gateway.id

  route_key = "PATCH /request"
  target = "integrations/${aws_apigatewayv2_integration.request_update.id}"
}

resource "aws_lambda_permission" "api_gw_request_update" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.request_update.function_name
  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.api_gateway.execution_arn}/*/*"
}

# cloud watch logs
resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.api_gateway.name}"

  retention_in_days = 30
}