resource "aws_apigatewayv2_api" "WindsWsApi" {
  name                       = "WindsWsApi"
  protocol_type              = "WEBSOCKET"
  route_selection_expression = "$request.body.action"
}

resource "aws_apigatewayv2_stage" "WindsWsApi_dev_stage" {
  api_id      = aws_apigatewayv2_api.WindsWsApi.id
  name        = "dev"
  auto_deploy = true
  # deployment_id = aws_apigatewayv2_deployment.WindsWsApi_dev_deployment.id
}

resource "aws_apigatewayv2_deployment" "WindsWsApi_dev_deployment" {
  api_id      = aws_apigatewayv2_api.WindsWsApi.id
  description = "Development deployment of the Winds Websocket API"
  depends_on = [
    aws_apigatewayv2_route.WindsWsApi_connect_route,
    # aws_apigatewayv2_route.WindsWsApi_disconnect_route,
    # aws_apigatewayv2_route.WindsWsApi_default_route,
  ]
  lifecycle {
    create_before_destroy = true
  }
}

output "websocket_url" {
  value = "${aws_apigatewayv2_api.WindsWsApi.api_endpoint}/dev"
}


