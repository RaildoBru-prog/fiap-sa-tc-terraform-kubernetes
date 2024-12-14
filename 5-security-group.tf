# Load balancer security group. CIDR and port ingress can be changed as required.
resource "aws_security_group" "lb_security_group" {
  name        = "tf-ecs-${var.name_app}-ALB-SG"
  description = "SG-ALB-${var.name_app}"
  vpc_id = aws_vpc.tech-challenge.id

}

resource "aws_security_group_rule" "sg_ingress_rule_all_to_lb" {
  type	= "ingress"
  description = "Allow from anyone on port 80"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb_security_group.id
}

# Load balancer security group egress rule to ECS cluster security group.
resource "aws_security_group_rule" "sg_egress_rule_lb_to_ecs_cluster" {
  type	= "egress"
  description = "Target group egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.lb_security_group.id
  source_security_group_id = aws_security_group.ecs_security_group.id
}

resource "aws_security_group" "ecs_security_group" {
  name        = "tf-ecs-${var.name_app} TASK SG"
  description = "tf-ecs-${var.name_app} SG"
  vpc_id      = aws_vpc.tech-challenge.id

  ingress {
    protocol        = "tcp"
    from_port       = var.container_port
    to_port         = var.container_port
    security_groups = [aws_security_group.lb_security_group.id]
  }


  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}