###########################
### SEND_WEIGHTS LAMBDA ###
###########################
resource "aws_lambda_function" "WindsSendWeightsLambda" {
  filename         = data.local_file.WindsSendWeightsLambda_payload.filename
  function_name    = "WindsSendWeightsLambda"
  role             = aws_iam_role.WindsSendWeightsLambda_role.arn
  handler          = "send_weights.handler"
  runtime          = local.lambda_runtime
  source_code_hash = data.local_file.WindsSendWeightsLambda_payload.content_base64sha256
  layers = [aws_lambda_layer_version.CommonLambdaLayer.arn]

  environment {
    variables = {
      "API_GATEWAY_ENDPOINT" = "https://${aws_apigatewayv2_api.WindsWsApi.id}.execute-api.${local.region}.amazonaws.com/${aws_apigatewayv2_stage.WindsWsApi_dev_stage.id}"
      "CONNECTIONS_TABLE"       = aws_dynamodb_table.WebsocketConnections.id
      "DISPATCHES_TABLE"       = aws_dynamodb_table.Dispatches.id
    }
  }
}
resource "aws_lambda_permission" "WindsSendWeightsLambda_permissions" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.WindsSendWeightsLambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.WindsWsApi.execution_arn}/*/*"
}
data "local_file" "WindsSendWeightsLambda_payload" {
  filename = "${path.module}/lambda_payloads/lambda_send_weights_payload.zip"
}

##################################
### REQUIRED WEBSOCKET LAMBDAS ###
##################################
resource "aws_lambda_function" "WindsConnectLambda" {
  filename         = data.local_file.WindsConnectLambda_payload.filename
  function_name    = "WindsConnectLambda"
  role             = aws_iam_role.WindsConnectLambda_role.arn
  handler          = "connect.handler"
  runtime          = local.lambda_runtime
  source_code_hash = data.local_file.WindsConnectLambda_payload.content_base64sha256
  layers = [aws_lambda_layer_version.CommonLambdaLayer.arn]

  environment {
    variables = {
      "API_GATEWAY_ENDPOINT" = "https://${aws_apigatewayv2_api.WindsWsApi.id}.execute-api.${local.region}.amazonaws.com/${aws_apigatewayv2_stage.WindsWsApi_dev_stage.id}"
      "CONNECTIONS_TABLE"       = aws_dynamodb_table.WebsocketConnections.id
    }
  }
}
resource "aws_lambda_permission" "WindsConnectLambda_permissions" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.WindsConnectLambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.WindsWsApi.execution_arn}/*/*"
}
data "local_file" "WindsConnectLambda_payload" {
  filename = "${path.module}/lambda_payloads/lambda_connect_payload.zip"
}


resource "aws_lambda_function" "WindsDisconnectLambda" {
  filename         = data.local_file.WindsDisconnectLambda_payload.filename
  function_name    = "WindsDisconnectLambda"
  role             = aws_iam_role.WindsDisconnectLambda_role.arn
  handler          = "disconnect.handler"
  runtime          = local.lambda_runtime
  source_code_hash = data.local_file.WindsDisconnectLambda_payload.content_base64sha256
  layers = [aws_lambda_layer_version.CommonLambdaLayer.arn]

  environment {
    variables = {
      "API_GATEWAY_ENDPOINT" = "https://${aws_apigatewayv2_api.WindsWsApi.id}.execute-api.${local.region}.amazonaws.com/${aws_apigatewayv2_stage.WindsWsApi_dev_stage.id}"
      "CONNECTIONS_TABLE"       = aws_dynamodb_table.WebsocketConnections.id
    }
  }
}
resource "aws_lambda_permission" "WindsDisconnectLambda_permissions" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.WindsDisconnectLambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.WindsWsApi.execution_arn}/*/*"
}
data "local_file" "WindsDisconnectLambda_payload" {
  filename = "${path.module}/lambda_payloads/lambda_disconnect_payload.zip"
}


resource "aws_lambda_function" "WindsDefaultLambda" {
  filename         = data.local_file.WindsDefaultLambda_payload.filename
  function_name    = "WindsDefaultLambda"
  role             = aws_iam_role.WindsDefaultLambda_role.arn
  handler          = "default.handler"
  runtime          = local.lambda_runtime
  source_code_hash = data.local_file.WindsDefaultLambda_payload.content_base64sha256
  layers = [aws_lambda_layer_version.CommonLambdaLayer.arn]

  environment {
    variables = {
      "API_GATEWAY_ENDPOINT" = "https://${aws_apigatewayv2_api.WindsWsApi.id}.execute-api.${local.region}.amazonaws.com/${aws_apigatewayv2_stage.WindsWsApi_dev_stage.id}"
      "CONNECTIONS_TABLE"       = aws_dynamodb_table.WebsocketConnections.id
    }
  }
}
resource "aws_lambda_permission" "WindsDefaultLambda_permissions" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.WindsDefaultLambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.WindsWsApi.execution_arn}/*/*"
}
data "local_file" "WindsDefaultLambda_payload" {
  filename = "${path.module}/lambda_payloads/lambda_default_payload.zip"
}

#####################
### LAMBDA LAYERS ###
#####################
# Common python source files for all lambdas
resource "aws_lambda_layer_version" "CommonLambdaLayer" {
  layer_name       = "lambda_common"
  description      = "lambda_common"
  filename         = data.local_file.CommonLambdaLayer.filename
  source_code_hash = data.local_file.CommonLambdaLayer.content_base64sha256
  compatible_runtimes = [local.lambda_runtime]
} 

data "local_file" "CommonLambdaLayer" {
  filename = "${path.module}/lambda_payloads/common_layer_payload.zip"
}