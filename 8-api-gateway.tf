resource "aws_apigatewayv2_vpc_link" "vpclink_apigw_to_alb" {
  name        = "vpclink_apigw_to_alb"
  security_group_ids = []

  subnet_ids = [
    aws_subnet.public-subnet-az1.id,
    aws_subnet.public-subnet-az2.id,
    aws_subnet.private-subnet-az1.id,
    aws_subnet.private-subnet-az2.id
  ]
}
resource "aws_apigatewayv2_api" "apigw_http_endpoint" {
  name          = "${var.name_app}-pvt-endpoint"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "apigw_integration" {
  api_id           = aws_apigatewayv2_api.apigw_http_endpoint.id
  integration_type = "HTTP_PROXY"
  integration_uri  = aws_lb_listener.ecs_alb_listener.arn

  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.vpclink_apigw_to_alb.id
  payload_format_version = "1.0"
  depends_on      = [aws_apigatewayv2_vpc_link.vpclink_apigw_to_alb,
    aws_apigatewayv2_api.apigw_http_endpoint,
    aws_lb_listener.ecs_alb_listener]
}

# API GW route with ANY method
resource "aws_apigatewayv2_route" "apigw_route" {
  api_id    = aws_apigatewayv2_api.apigw_http_endpoint.id
  route_key = "ANY /{proxy+}"
  target = "integrations/${aws_apigatewayv2_integration.apigw_integration.id}"
  # add lambda
  depends_on  = [aws_apigatewayv2_integration.apigw_integration]
}

# # API Gateway V2 Route with Authorizer
# resource "aws_apigatewayv2_route" "example_route" {
#   api_id    = aws_apigatewayv2_api.http_api.id
#   route_key = "GET /validator"  # Replace with your desired method and path

#   target = "integrations/${aws_apigatewayv2_integration.backend_integration.id}"
  
#   # Link the authorizer to this route
#   authorizer_id = aws_apigatewayv2_authorizer.lambda_authorizer.id
#   authorization_type = "CUSTOM"
# }


# Set a default stage
resource "aws_apigatewayv2_stage" "apigw_stage" {
  api_id = aws_apigatewayv2_api.apigw_http_endpoint.id
  name   = "$default"
  auto_deploy = true
  depends_on  = [aws_apigatewayv2_api.apigw_http_endpoint]
}



