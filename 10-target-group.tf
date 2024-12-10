resource "aws_lb_target_group" "tech-challenge" {
    name = "target-group"
    port = 30000
    target_type = "ip"
    protocol = "HTTP"

    vpc_id = aws_vpc.tech-challenge.id
}

data "aws_eks_cluster" "example" {
  name = aws_eks_cluster.tech-challenge.name
}

data "aws_eks_node_group" "example" {
  cluster_name = aws_eks_cluster.tech-challenge.name
  node_group_name = aws_eks_node_group.tech-challenge.node_group_name
}

data "aws_instances" "example" {
  filter {
    name   = "tag:eks:eks"
    values = [data.aws_eks_cluster.example.name]
  }
}

resource "aws_lb_target_group_attachment" "example" {
  count             = length(data.aws_instances.example.ids)
  target_group_arn  = aws_lb_target_group.tech-challenge.arn
  target_id         = data.aws_instances.example.ids[count.index]
  port              = 30000
}

#Instance port