###########################################################
# AWS CONTAINER_DEFINITION TEMPLATE_FILE
###########################################################
# data "template_file" "container_definitions" {
#   template = "${file("${path.module}/container-definitions/container-def.json")}"
#   vars = {
#     dbhost              = var.container_definitions__dbhost
#     postgres_user       = var.container_definitions__postgres_user
#     postgres_password   = var.container_definitions__postgres_password
#   }
# }


data "aws_ecs_task_definition" "task-definition-test"  {
  task_definition = aws_ecs_task_definition.task-definition-test.family
}