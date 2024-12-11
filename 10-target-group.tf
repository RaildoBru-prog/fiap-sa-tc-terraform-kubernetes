resource "aws_lb_target_group" "tech-challenge" {
    name = "target-group"
    port = 30000
    target_type = "ip"
    protocol = "HTTP"

    vpc_id = aws_vpc.tech-challenge.id
}

# data "aws_eks_cluster" "eks" {
#   name = aws_eks_cluster.tech-challenge.name
# }

# data "aws_instances" "instances" {
#   instance_tags = {
#     "eks:cluster-name" = aws_eks_cluster.tech-challenge.name
#     "eks:nodegroup-name" = aws_eks_node_group.tech-challenge.node_group_name
#   }
# }

# resource "aws_lb_target_group_attachment" "example" {
#   target_group_arn  = aws_lb_target_group.tech-challenge.arn
#   target_id         = data.aws_instances.instances.ids[0]
#   port              = 30000
# }
