resource "aws_security_group" "security-group-vpc-link" {
  name        = "security-group-vpc-link"
  vpc_id      = aws_vpc.tech-challenge.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP from anywhere (for demo purposes)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }

  tags = {
    Name = "ALB-Security-Group"
  }
}

resource "aws_apigatewayv2_vpc_link" "tech-challenge" {
  name        = "vpclink_apigw_to_alb"
  security_group_ids = [aws_security_group.security-group-vpc-link.id]
  subnet_ids = [
    aws_subnet.private-subnet-az1.id,
    aws_subnet.private-subnet-az2.id,
    aws_subnet.public-subnet-az1.id,
    aws_subnet.public-subnet-az2.id
  ]
}