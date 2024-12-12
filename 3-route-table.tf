resource "aws_internet_gateway" "tech-challenge" {
    vpc_id = aws_vpc.tech-challenge.id

    tags = {
        Name = "tech-challenge"
    }
}

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

resource "aws_route_table" "route-table-public" {
    vpc_id = aws_vpc.tech-challenge.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.tech-challenge.id
    }

    tags = {
      Name = "route-table-public"
    }
}

resource "aws_route_table" "route-table-private-az1" {
    vpc_id = aws_vpc.tech-challenge.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.tech-challenge-az1.id
    }

    tags = {
      Name = "route-table-private-az1"
    }
}

resource "aws_route_table" "route-table-private-az2" {
    vpc_id = aws_vpc.tech-challenge.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.tech-challenge-az2.id
    }

    tags = {
      Name = "route-table-private-az2"
    }
}

### ASSOCIATIONS

resource "aws_route_table_association" "route-table-association-public-a" {
    subnet_id       = aws_subnet.public-subnet-az1.id
    route_table_id  = aws_route_table.route-table-public.id
}

resource "aws_route_table_association" "route-table-association-public-b" {
    subnet_id       = aws_subnet.public-subnet-az2.id
    route_table_id  = aws_route_table.route-table-public.id
}


resource "aws_route_table_association" "route-table-association-private-az1" {
    subnet_id       = aws_subnet.private-subnet-az1.id
    route_table_id  = aws_route_table.route-table-private-az1.id
}

resource "aws_route_table_association" "route-table-association-private-az2" {
    subnet_id       = aws_subnet.private-subnet-az2.id
    route_table_id  = aws_route_table.route-table-private-az2.id
}