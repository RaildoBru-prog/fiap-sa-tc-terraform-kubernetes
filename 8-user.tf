data "aws_caller_identity" "current" {}


# dando permissao pra mim acessar o dashboard na aws
resource "aws_iam_role" "eks_admin" {
  name = "tc-eks-admin"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "arn:aws:iam::${var.account-id}:root"
      }
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "eks_admin" {
  name = "AmazonEKSAdminPolicy"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:PassedToService": "eks.amazonaws.com"
                }
            }
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks_admin" {
  role       = aws_iam_role.eks_admin.name
  policy_arn = aws_iam_policy.eks_admin.arn
}

resource "aws_eks_access_entry" "manager" {
  cluster_name      = aws_eks_cluster.tech-challenge.name
  principal_arn     = aws_iam_role.eks_admin.arn
  kubernetes_groups = ["system:masters"]
}
