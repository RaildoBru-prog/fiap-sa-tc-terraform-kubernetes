data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "private-subnet-az1" {
    vpc_id = aws_vpc.tech-challenge.id
    availability_zone = data.aws_availability_zones.available.names[0]
    cidr_block = "10.0.0.0/19"

    tags = {
      Name = "private-subnet"
      "kubernetes.io/role/internal-elb" = "1"
      "kubernetes.io/cluster/eks" = "owned"
    }
}

resource "aws_subnet" "private-subnet-az2" {
    vpc_id = aws_vpc.tech-challenge.id
    availability_zone = data.aws_availability_zones.available.names[1]
    cidr_block = "10.0.32.0/19"

    tags = {
      Name = "private-subnet"
      "kubernetes.io/role/internal-elb" = "1"
      "kubernetes.io/cluster/eks" = "owned"
    }
}

resource "aws_subnet" "public-subnet-az1" {
    vpc_id = aws_vpc.tech-challenge.id
    availability_zone = data.aws_availability_zones.available.names[0]
    cidr_block = "10.0.64.0/19"
    map_public_ip_on_launch = true
    tags = {
      Name = "public-subnet"
      "kubernetes.io/role/elb" = "1"
      "kubernetes.io/cluster/eks" = "owned"
    }
}

resource "aws_subnet" "public-subnet-az2" {
    vpc_id = aws_vpc.tech-challenge.id
    availability_zone = data.aws_availability_zones.available.names[1]
    cidr_block = "10.0.96.0/19"
    map_public_ip_on_launch = true
    tags = {
      Name = "public-subnet"
      "kubernetes.io/role/elb" = "1"
      "kubernetes.io/cluster/eks" = "owned"
    }
}