##########################
### SEND WEIGHTS ROUTE ###
##########################
resource "aws_apigatewayv2_integration" "WindsWsApi_WindsSendWeightsLambda_integration" {
  api_id                    = aws_apigatewayv2_api.WindsWsApi.id
  integration_type          = "AWS_PROXY"
  integration_uri           = aws_lambda_function.WindsSendWeightsLambda.invoke_arn
  credentials_arn           = aws_iam_role.WindsWsApi_role.arn
  content_handling_strategy = "CONVERT_TO_TEXT"
  passthrough_behavior      = "WHEN_NO_MATCH"
}
resource "aws_apigatewayv2_route" "WindsWsApi_send_weights_route" {
  api_id    = aws_apigatewayv2_api.WindsWsApi.id
  route_key = "send_weights"
  target    = "integrations/${aws_apigatewayv2_integration.WindsWsApi_WindsSendWeightsLambda_integration.id}"
}

#################################
### REQUIRED WEBSOCKET ROUTES ###
#################################
resource "aws_apigatewayv2_integration" "WindsWsApi_WindsConnectLambda_integration" {
  api_id                    = aws_apigatewayv2_api.WindsWsApi.id
  integration_type          = "AWS_PROXY"
  integration_uri           = aws_lambda_function.WindsConnectLambda.invoke_arn
  credentials_arn           = aws_iam_role.WindsWsApi_role.arn
  content_handling_strategy = "CONVERT_TO_TEXT"
  passthrough_behavior      = "WHEN_NO_MATCH"
}
resource "aws_apigatewayv2_route" "WindsWsApi_connect_route" {
  api_id    = aws_apigatewayv2_api.WindsWsApi.id
  route_key = "$connect"
  target    = "integrations/${aws_apigatewayv2_integration.WindsWsApi_WindsConnectLambda_integration.id}"
}

resource "aws_apigatewayv2_integration" "WindsWsApi_WindsDisconnectLambda_integration" {
  api_id                    = aws_apigatewayv2_api.WindsWsApi.id
  integration_type          = "AWS_PROXY"
  integration_uri           = aws_lambda_function.WindsDisconnectLambda.invoke_arn
  credentials_arn           = aws_iam_role.WindsWsApi_role.arn
  content_handling_strategy = "CONVERT_TO_TEXT"
  passthrough_behavior      = "WHEN_NO_MATCH"
}
resource "aws_apigatewayv2_route" "WindsWsApi_disconnect_route" {
  api_id    = aws_apigatewayv2_api.WindsWsApi.id
  route_key = "$disconnect"
  target    = "integrations/${aws_apigatewayv2_integration.WindsWsApi_WindsDisconnectLambda_integration.id}"
}

resource "aws_apigatewayv2_integration" "WindsWsApi_WindsDefaultLambda_integration" {
  api_id                    = aws_apigatewayv2_api.WindsWsApi.id
  integration_type          = "AWS_PROXY"
  integration_uri           = aws_lambda_function.WindsDefaultLambda.invoke_arn
  credentials_arn           = aws_iam_role.WindsWsApi_role.arn
  content_handling_strategy = "CONVERT_TO_TEXT"
  passthrough_behavior      = "WHEN_NO_MATCH"
}
resource "aws_apigatewayv2_route" "WindsWsApi_default_route" {
  api_id    = aws_apigatewayv2_api.WindsWsApi.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.WindsWsApi_WindsDefaultLambda_integration.id}"
}
