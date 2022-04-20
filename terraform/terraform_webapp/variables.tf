variable "key_name" {
  type        = string
  description = "The name for ssh key, used for aws_launch_configuration"
}

variable "cluster_name" {
  type        = string
  description = "The name of AWS ECS cluster"
}

# -var="key_name=id_rsa" -var="cluster_name=test_cluster"