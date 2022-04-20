variable "username" {
  type        = string
  description = "The name for the postgre db user"
}

variable "password" {
  type        = string
  description = "The password for the postgre db user"
}

# variable "key_name" {
#   type        = string
#   description = "The name for ssh key, used for aws_launch_configuration"
# }

# -var="username=postgres" -var="password=password123" -var="db_name=app"