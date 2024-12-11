resource "aws_iam_role" "nodes" {
  name = "tech-challenge-eks-nodes"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    }
  ]
}
POLICY
}

# This policy now includes AssumeRoleForPodIdentity for the Pod Identity Agent
resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes.name
}

resource "aws_eks_node_group" "tech-challenge" {
    cluster_name = aws_eks_cluster.tech-challenge.name
    version = "1.31"
    node_group_name = "tech-challenge"
    node_role_arn = aws_iam_role.nodes.arn
    
    subnet_ids = [
        aws_subnet.public-subnet-az1.id,
        aws_subnet.public-subnet-az2.id
    ] 

    capacity_type = "ON_DEMAND"
    instance_types = ["t3.medium"]

    scaling_config {
      desired_size = 1
      max_size = 5
      min_size = 1
    }

    update_config {
        max_unavailable = 1
    }

    labels = {
      role = "general"
    }

    depends_on = [
        aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
        aws_iam_role_policy_attachment.amazon_eks_cni_policy,
        aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
    ]

}