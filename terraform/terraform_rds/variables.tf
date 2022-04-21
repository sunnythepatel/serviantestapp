variable "username" {
  type        = string
  description = "The name for the postgre db user"
  default = "postgres"
}

variable "password" {
  type        = string
  description = "The password for the postgre db pasword"
}


# -var="username=postgres" -var="password=password123" -var="db_name=app"