resource "aws_ecr_repository" "app-ecr-repository" {
  name                 = var.name_app
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = false
  }
}