resource "aws_iam_role" "eks" {
  name = "tech-challenge-eks-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "eks.amazonaws.com"
      }
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks.name
}

resource "aws_security_group" "security-group-eks" {
  name        = "security-group-eks"
  vpc_id      = aws_vpc.tech-challenge.id

  ingress {
    description = "alb"
    from_port   = 30000
    to_port     = 30000
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "kubernetes.io/cluster/eks": "owned"
  }
}

resource "aws_eks_cluster" "tech-challenge" {
    name = "eks"
    version = "1.31"
    role_arn = aws_iam_role.eks.arn

    vpc_config {
      
        subnet_ids = [
            aws_subnet.private-subnet-az1.id,
            aws_subnet.private-subnet-az2.id,
            aws_subnet.public-subnet-az1.id,
            aws_subnet.public-subnet-az2.id
        ]
    
       security_group_ids = [aws_security_group.security-group-eks.id]
    }
    
    access_config {
      authentication_mode = "API" # auths config map
      bootstrap_cluster_creator_admin_permissions = true
    }

    depends_on = [ aws_iam_role_policy_attachment.eks ]
}