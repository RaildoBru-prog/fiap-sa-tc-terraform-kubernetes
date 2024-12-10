# provider "aws" {
#   region = "us-east-1"
# }

# data "aws_availability_zones" "available" {
#   state = "available"
# }

# resource "aws_vpc" "tc_vpc" {
#   cidr_block = "10.0.0.0/16"
#   tags = {
#     Name = "tech-challenge-vpc"
#   }
# }

# # resource "aws_ecr_repository" "tc_ecr" {
# #   name                 = "tech-challenge-ecr"
# #   image_tag_mutability = "MUTABLE"

# #   image_scanning_configuration {
# #     scan_on_push = false
# #   }

# #   tags = {
# #     Name = "tech-challenge-ecr"
# #   }
# # }

# # resource "aws_secretsmanager_secret" "tc_secrets" {
# #   name = "tech-challenge-secrets"
# # }

# resource "aws_subnet" "tc_subnet_primary" {
#   vpc_id     = aws_vpc.tc_vpc.id
#   cidr_block = "10.0.1.0/24"
#   map_public_ip_on_launch = false
#   availability_zone = data.aws_availability_zones.available.names[0]
  
#   tags = {
#     Name = "tech-challenge-private-subnet-primary"
#   }
# }

# resource "aws_subnet" "tc_subnet_secondary" {
#   vpc_id     = aws_vpc.tc_vpc.id
#   cidr_block = "10.0.2.0/24"
#   map_public_ip_on_launch = false
#   availability_zone = data.aws_availability_zones.available.names[1]
  
#   tags = {
#     Name = "tech-challenge-private-subnet-secondary"
#   }
# }


# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.tc_vpc.id

#   tags = {
#     Name = "tech-challenge-igw"
#   }
# }

# resource "aws_subnet" "public_zone1" {
#   vpc_id                  = aws_vpc.tc_vpc.id
#   cidr_block              = "10.0.64.0/19"
#   availability_zone       = data.aws_availability_zones.available.names[0]
#   map_public_ip_on_launch = true

#   tags = {
#     "Name"                                                 = "tech-challenge-public-${data.aws_availability_zones.available.names[0]}"
#   }
# }

# resource "aws_eip" "nat" {
#   domain = "vpc"

#   tags = {
#     Name = "tech-challenge-nat"
#   }
# }

# resource "aws_nat_gateway" "nat" {
#   allocation_id = aws_eip.nat.id
#   subnet_id     = aws_subnet.public_zone1.id

#   tags = {
#     Name = "tech-challenge-nat"
#   }

#   depends_on = [aws_internet_gateway.igw]
# }

# resource "aws_route_table" "private" {
#   vpc_id = aws_vpc.tc_vpc.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat.id
#   }

#   tags = {
#     Name = "tech-challenge-private"
#   }
# }

# resource "aws_route_table" "public" {
#   vpc_id = aws_vpc.tc_vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }

#   tags = {
#     Name = "tech-challenge-public"
#   }
# }

# resource "aws_route_table_association" "public_zone1" {
#   subnet_id      = aws_subnet.public_zone1.id
#   route_table_id = aws_route_table.public.id
# }

# resource "aws_route_table_association" "private_zone1" {
#   subnet_id      = aws_subnet.tc_subnet_primary.id
#   route_table_id = aws_route_table.private.id
# }

# resource "aws_route_table_association" "private_zone2" {
#   subnet_id      = aws_subnet.tc_subnet_secondary.id
#   route_table_id = aws_route_table.private.id
# }

# # criacao da minha vpc
# # criacao dos meus ranges de ip [subnets]
# # criacao de um EIP para o internet gateway
# # criacao de um nat para trafego das subnets privadas
# #   para a internet
# # criacao de uma table route para configuracao de trafego
# #   das subnets


# # internet-gateway; <- criado um novo igw e atachado na vpc
# # 
# # vpc {
# #
# #   route-table; <- cria o roteamento para o igw "Conexao publica"
# #
# #   public-subnet {
# #     nat-gateway [eip]; <- cria e atribui um elastic ip para 
# #   }                       criar o roteamento 
# #
# #   route-table; <- cria o roteamento para o nat "Conexao privada"
# #
# #   private-subnet {
# #     eks;
# #   }

# # }


# # nat-gateway: transcreve de um ip para outro as requisiçoes de trafego
# #               sai do eks com um ip privado e o nat "traduz"
# #               para o EIP. O roteamento criado faz com que 
# #               o EIP tenha acesso a internet via o internet gateway


# # definir as regioes e az na mao, se nao ele cria aleatoriamente


# # Sercurity groups + ACL

# # VPC CNI - "policy" arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy
# # - network plugin for pod 

# # RBAC


# # como um kubectl se conecta em um EKS com subnet privada

# # AmazonEKSClusterPolicy
# # AmazonEKSServicePolicy 

###################################################################
# Amazon EKS Pod Identity Agent
# CoreDNS
# kube-proxy
# EKSAutoNodeRTole

# Kubernetes labels
# tains

# AMI Type
# Disk size