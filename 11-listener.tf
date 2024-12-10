resource "aws_lb_listener" "tech-challenge" {
  load_balancer_arn = aws_lb.tech-challenge.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tech-challenge.id
  }
}