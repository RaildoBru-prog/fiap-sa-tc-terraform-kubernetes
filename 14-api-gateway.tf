resource "aws_apigatewayv2_api" "tech-challenge" {
  name          = "serverlessland-pvt-endpoint"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "tech-challenge" {
  api_id           = aws_apigatewayv2_api.tech-challenge.id
  integration_type = "HTTP_PROXY"
  integration_uri  = aws_lb_listener.tech-challenge.arn

  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.tech-challenge.id
  payload_format_version = "1.0"
  
  depends_on      = [aws_apigatewayv2_vpc_link.tech-challenge, 
                    aws_apigatewayv2_api.tech-challenge]
}

resource "aws_apigatewayv2_stage" "dev" {
  api_id = aws_apigatewayv2_api.tech-challenge.id
  name   = "dev"
  auto_deploy = true
}

resource "aws_apigatewayv2_route" "apigw_route" {
  api_id        = aws_apigatewayv2_api.tech-challenge.id
  route_key     = "ANY /{proxy+}"
  target        = "integrations/${aws_apigatewayv2_integration.tech-challenge.id}"
  depends_on    = [aws_apigatewayv2_integration.tech-challenge]
}

# resource "aws_apigatewayv2_route" "post_handler" {
#   api_id    = aws_apigatewayv2_api.tech-challenge.id
#   route_key = "POST /authorizer"

#   target = "integrations/${aws_apigatewayv2_integration.tech-challenge.id}"
# }