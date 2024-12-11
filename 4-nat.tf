resource "aws_eip" "eip-az1" {
    domain = "vpc"
    
    depends_on = [ 
        aws_internet_gateway.tech-challenge
     ]
}

resource "aws_eip" "eip-az2" {
    domain = "vpc"

    depends_on = [ 
        aws_internet_gateway.tech-challenge
    ]
}

resource "aws_nat_gateway" "tech-challenge-az1" {
    allocation_id = aws_eip.eip-az1.id
    subnet_id = aws_subnet.public-subnet-az1.id
}

resource "aws_nat_gateway" "tech-challenge-az2" {
    allocation_id = aws_eip.eip-az2.id
    subnet_id = aws_subnet.public-subnet-az2.id
}