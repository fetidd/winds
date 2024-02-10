resource "aws_cloudwatch_log_group" "WindsConnectLambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.WindsConnectLambda.function_name}"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_group" "WindsDisconnectLambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.WindsDisconnectLambda.function_name}"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_group" "WindsDefaultLambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.WindsDefaultLambda.function_name}"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_group" "WindsSendWeightsLambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.WindsSendWeightsLambda.function_name}"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_group" "WindsWsApi_logs" {
  name              = "/aws/apigateway/WindsWsApi"
  retention_in_days = 1
}