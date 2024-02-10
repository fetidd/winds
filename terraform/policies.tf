#######################
### LAMBDA POLICIES ###
#######################
data "aws_iam_policy_document" "WindsSendWeightsLambda_policy" {
  # Allow the lmabda to log events
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:*"]
  }
  # Allow the lambda to do CRUD operations on the table
  statement {
    actions = [
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
      "dynamodb:Scan",
      "dynamodb:GetItem",
    ]
    effect    = "Allow"
    resources = [
      aws_dynamodb_table.WebsocketConnections.arn,
      aws_dynamodb_table.Dispatches.arn,
    ]
  }
  # Allow the lambda to execute the API ???
  statement {
    actions = [
      "execute-api:*",
    ]
    effect = "Allow"
    resources = [
      "${aws_apigatewayv2_stage.WindsWsApi_dev_stage.execution_arn}/*/*/*"
    ]
  }
}

resource "aws_iam_policy" "WindsSendWeightsLambda_policy" {
  name   = "WindsSendWeightsLambda_policy"
  path   = "/"
  policy = data.aws_iam_policy_document.WindsSendWeightsLambda_policy.json
}

data "aws_iam_policy_document" "WindsConnectLambda_policy" {
  # Allow the lmabda to log events
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:*"]
  }
  # Allow the lambda to do CRUD operations on the table
  statement {
    actions = [
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
      "dynamodb:Scan",
      "dynamodb:GetItem",
    ]
    effect    = "Allow"
    resources = [aws_dynamodb_table.WebsocketConnections.arn]
  }
  # Allow the lambda to execute the API ???
  statement {
    actions = [
      "execute-api:*",
    ]
    effect = "Allow"
    resources = [
      "${aws_apigatewayv2_stage.WindsWsApi_dev_stage.execution_arn}/*/*/*"
    ]
  }
}

resource "aws_iam_policy" "WindsConnectLambda_policy" {
  name   = "WindsConnectLambda_policy"
  path   = "/"
  policy = data.aws_iam_policy_document.WindsConnectLambda_policy.json
}

data "aws_iam_policy_document" "WindsDisconnectLambda_policy" {
  # Allow the lmabda to log events
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:*"]
  }
  # Allow the lambda to do CRUD operations on the table
  statement {
    actions = [
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
      "dynamodb:Scan",
      "dynamodb:GetItem",
    ]
    effect    = "Allow"
    resources = [aws_dynamodb_table.WebsocketConnections.arn]
  }
  # Allow the lambda to execute the API ???
  statement {
    actions = [
      "execute-api:*",
    ]
    effect = "Allow"
    resources = [
      "${aws_apigatewayv2_stage.WindsWsApi_dev_stage.execution_arn}/*/*/*"
    ]
  }
}

resource "aws_iam_policy" "WindsDisconnectLambda_policy" {
  name   = "WindsDisconnectLambda_policy"
  path   = "/"
  policy = data.aws_iam_policy_document.WindsDisconnectLambda_policy.json
}

data "aws_iam_policy_document" "WindsDefaultLambda_policy" {
  # Allow the lmabda to log events
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:*"]
  }
  # Allow the lambda to do CRUD operations on the table
  statement {
    actions = [
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
      "dynamodb:Scan",
      "dynamodb:GetItem",
    ]
    effect    = "Allow"
    resources = [aws_dynamodb_table.WebsocketConnections.arn]
  }
  # Allow the lambda to execute the API ???
  statement {
    actions = [
      "execute-api:*",
    ]
    effect = "Allow"
    resources = [
      "${aws_apigatewayv2_stage.WindsWsApi_dev_stage.execution_arn}/*/*/*"
    ]
  }
}

resource "aws_iam_policy" "WindsDefaultLambda_policy" {
  name   = "WindsDefaultLambda_policy"
  path   = "/"
  policy = data.aws_iam_policy_document.WindsDefaultLambda_policy.json
}


############################
### API GATEWAY POLICIES ###
############################
data "aws_iam_policy_document" "WindsWsApi_policy" {
  # Allow the gateway to invoke the lambda function
  statement {
    actions = [
      "lambda:InvokeFunction",
    ]
    effect    = "Allow"
    resources = [
      aws_lambda_function.WindsConnectLambda.arn,
      aws_lambda_function.WindsDefaultLambda.arn,
      aws_lambda_function.WindsDisconnectLambda.arn,
      aws_lambda_function.WindsSendWeightsLambda.arn,
    ]
  }
  # Allow the gateway to log events
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:*"]
  }
}


resource "aws_iam_policy" "WindsWsApi_policy" {
  name   = "WindsWsApi_policy"
  path   = "/"
  policy = data.aws_iam_policy_document.WindsWsApi_policy.json
}

