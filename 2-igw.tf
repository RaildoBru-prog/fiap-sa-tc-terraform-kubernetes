resource "aws_internet_gateway" "tech-challenge" {
    vpc_id = aws_vpc.tech-challenge.id

    tags = {
        Name = "tech-challenge"
    }
}

