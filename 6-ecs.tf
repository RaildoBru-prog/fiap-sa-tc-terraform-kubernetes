# Create the ECS Cluster and Fargate launch type service in the private subnets
resource "aws_ecs_cluster" "ecs_cluster" {
 name = local.cluster_name
}

resource "aws_ecs_task_definition" "ecs_task_def" {
 family                   = local.cluster_task
 container_definitions    = <<DEFINITION
 [
   {
     "name": "${local.cluster_task}",
     "image": "${aws_ecr_repository.app-ecr-repository.repository_url}:latest",
     "environment": [
     {
        "name": "aws.key",
        "value": "${var.access_key}"
     },
     {
        "name": "aws.secret",
        "value": "${var.secret_key}"
     }
     ],
     "essential": true,
     "portMappings": [
       {
         "containerPort": ${var.container_port},
         "hostPort": ${var.container_port},
         "protocol": "http"
       }
     ],
     "memory": ${var.memory},
     "cpu": ${var.cpu}
   }
 ]
 DEFINITION
 requires_compatibilities = ["FARGATE"]
 network_mode             = "awsvpc"
 memory                   = var.memory
 cpu                      = var.cpu
 execution_role_arn       = aws_iam_role.ecs_task_exec_role.arn
}


resource "aws_iam_role" "ecs_task_exec_role" {
 name               = "${var.name_app}_ecs_task_role"
 assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}


data "aws_iam_policy_document" "assume_role_policy" {
 statement {
   actions = ["sts:AssumeRole"]


   principals {
     type        = "Service"
     identifiers = ["ecs-tasks.amazonaws.com"]
   }
 }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
 role       = aws_iam_role.ecs_task_exec_role.name
 policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_service" "app-ecs-service" {
 name                = local.cluster_service
 cluster             = aws_ecs_cluster.ecs_cluster.id
 task_definition     = aws_ecs_task_definition.ecs_task_def.arn
 launch_type         = "FARGATE"
 ##scheduling_strategy = "REPLICA"
 desired_count       = var.desired_capacity
 depends_on      = [aws_lb_target_group.alb_ecs_tg, aws_lb_listener.ecs_alb_listener]


 load_balancer {
   target_group_arn = aws_lb_target_group.alb_ecs_tg.arn
   container_name   = aws_ecs_task_definition.ecs_task_def.family
   container_port   = var.container_port
 }


 network_configuration {
   subnets          = [
    aws_subnet.private-subnet-az1.id,
    aws_subnet.private-subnet-az2.id,
  ]
   security_groups  = [aws_security_group.ecs_security_group.id]
 }
}
