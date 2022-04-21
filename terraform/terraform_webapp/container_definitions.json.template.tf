data "template_file" "container_definitions" {
  template = file("container-definitions/container-def.json")

  vars = {
    dbhost              = var.container_definitions__dbhost
    postgres_user       = var.container_definitions__postgres_user
    postgres_password   = var.container_definitions__postgres_password
  }
}