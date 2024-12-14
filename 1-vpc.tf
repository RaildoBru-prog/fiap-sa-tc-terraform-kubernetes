resource "aws_vpc" "tech-challenge" {
    cidr_block              = "10.0.0.0/16"

    tags = {
        Name = "tech-challenge"
    }
}