# resource "aws_iam_role" "handler_lambda_exec" {
#   name = "handler-lambda"

#   assume_role_policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "lambda.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# POLICY
# }

# resource "aws_iam_role_policy_attachment" "handler_lambda_policy" {
#   role       = aws_iam_role.handler_lambda_exec.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }



# resource "aws_lambda_function" "authorizer" {
#   function_name = "authorizer"

#   runtime = "nodejs22.x"
#   handler = "function.handler"

#   source_code_hash = data.archive_file.handler.output_base64sha256

#   role = aws_iam_role.handler_lambda_exec.arn
# }

# resource "aws_lambda_permission" "api_gw" {
#   statement_id  = "AllowExecutionFromAPIGateway"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.authorizer.function_name
#   principal     = "apigateway.amazonaws.com"

#   source_arn = "${aws_apigatewayv2_api.tech-challenge.execution_arn}/*/*"
# }
