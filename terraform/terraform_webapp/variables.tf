variable "key_name" {
  type        = string
  description = "The name for ssh key, used for aws_launch_configuration"
}

variable "cluster_name" {
  type        = string
  description = "The name of AWS ECS cluster"
  default = "serviancluster"
}

variable "container_definitions__dbhost" {
  type = string
  description = "The name of the RDS DB Host"
}
variable "container_definitions__postgres_user" {
  type = string
  description = "The name of the RDS DB username"
  default = "postgres" 
  }
variable "container_definitions__postgres_password" {
  type = string
  description = "The name of the RDS DB password"
}


# -var="key_name=id_rsa" -var="cluster_name=test_cluster"