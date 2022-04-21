############################################################
# AWS ECS-CLUSTER
# Decription: Cluster is created using container instances 
#(EC2 launch type, not Fargate!).
# cluster of container instances web-cluster
############################################################
resource "aws_ecs_cluster" "web-cluster" {
  name               = var.cluster_name
  capacity_providers = [aws_ecs_capacity_provider.test.name]
  tags = {
    "env"       = "dev"
    "createdBy" = "servian"
  }
}

############################################################
# AWS ECS-CAPACITY-PROVIDER
# Description: capacity provider, which is basically AWS 
# Autoscaling group for EC2 instances. 
# In this example managed scaling is enabled, 
# Amazon ECS manages the scale-in and scale-out actions 
# of the Auto Scaling group used when creating the capacity
# provider. I set target capacity to 85%, which 
# will result in the Amazon EC2 instances in your 
# Auto Scaling group being utilized for 85% and any 
# instances not running any tasks will be scaled in.
############################################################
resource "aws_ecs_capacity_provider" "test" {
  name = "capacity-provider-test"
  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.asg.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      status          = "ENABLED"
      target_capacity = 85
    }
  }
}

############################################################
# AWS ECS-TASK-DEFINITION
# Description: task definition with family web-family, 
# volume and container definition is defined in the 
# file container-def.json
############################################################
resource "aws_ecs_task_definition" "task-definition-test" {
  family                = "web-family"
  container_definitions = <<DEFINITION
  [{
        "name": "db",
        "image": "postgres:9.6-alpine",
        "cpu": 5,
        "memory": 50,
        "essential": false,
        "command": [
            "/bin/sh", "-exc", "psql --host=${var.dbhost} --port=5432 --username=${var.postgres_user} --no-password  -c 'ALTER TABLESPACE pg_default OWNER TO ${var.postgres_user};'"
        ],
        "environment": [{
                "name": "POSTGRES_USER",
                "value": "${var.postgres_user}"
            },
            {
                "name": "PGPASSWORD",
                "value": "${var.postgres_password}"
            }
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "/ecs/db-container",
                "awslogs-region": "ap-southeast-2"
            }
        }
    },
    {
        "name": "myapp",
        "image": "servian/techchallengeapp:latest",
        "cpu": 10,
        "memory": 256,
        "essential": true,
        "portMappings": [{
            "containerPort": 80
        }],
        "command": [
            "serve"
        ],
        "environment": [{
                "name": "VTT_DBUSER",
                "value": "${var.postgres_user}"
            },
            {
                "name": "VTT_DBPASSWORD",
                "value": "${var.postgres_password}"
            },
            {
                "name": "VTT_DBNAME",
                "value": "app"
            },
            {
                "name": "VTT_DBPORT",
                "value": "5432"
            },
            {
                "name": "VTT_DBHOST",
                "value": "${var.dbhost}"
            },
            {
                "name": "VTT_LISTENHOST",
                "value": "0.0.0.0"
            },
            {
                "name": "VTT_LISTENPORT",
                "value": "80"
            }
        ],
        "dependsOn": [{
                "containerName": "db",
                "condition": "SUCCESS"
            },
            {
                "containerName": "webdb",
                "condition": "SUCCESS"
            }
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "/ecs/frontend-container",
                "awslogs-region": "ap-southeast-2"
            }
        }
    },
    {
        "name": "webdb",
        "image": "servian/techchallengeapp:latest",
        "cpu": 5,
        "memory": 50,
        "essential": false,
        "command": [
            "updatedb"
        ],
        "environment": [{
                "name": "VTT_DBUSER",
                "value": "${var.postgres_user}"
            },
            {
                "name": "VTT_DBPASSWORD",
                "value": "${var.postgres_password}"
            },
            {
                "name": "VTT_DBNAME",
                "value": "app"
            },
            {
                "name": "VTT_DBPORT",
                "value": "5432"
            },
            {
                "name": "VTT_DBHOST",
                "value": "${var.dbhost}"
            },
            {
                "name": "VTT_LISTENHOST",
                "value": "0.0.0.0"
            },
            {
                "name": "VTT_LISTENPORT",
                "value": "80"
            }
        ],
        "dependsOn": [{
            "containerName": "db",
            "condition": "SUCCESS"
        }],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "/ecs/webdb-container",
                "awslogs-region": "ap-southeast-2"
            }
        }
    }
]
DEFINITION
  network_mode          = "bridge"
  tags = {
    "env"       = "dev"
    "createdBy" = "servian"
  }
}

data "aws_ecs_task_definition" "task-definition-test"  {
  task_definition = aws_ecs_task_definition.task-definition-test.family
}

##############################################################
# AWS ECS-SERVICE
# Description: service web-service, desired count is set to 5,
# which means there are 5 tasks which will be running 
# simultaneously on your cluster. There are two service 
# scheduler strategies available: REPLICA and DAEMON, 
# in this deployment REPLICA is used. 
# Application load balancer is attached to this service,
# so the traffic can be distributed between those tasks.
#The binpack task placement strategy is used, which places 
# tasks on available instances that have the least 
# available amount of the cpu (specified with the 
# field parameter).
##############################################################
resource "aws_ecs_service" "service" {
  name            = "web-service"
  cluster         = aws_ecs_cluster.web-cluster.id
  task_definition = "${aws_ecs_task_definition.task-definition-test.family}:${data.aws_ecs_task_definition.task-definition-test.revision}"
  desired_count   = 5
  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.lb_target_group.arn
    container_name   = "myapp"
    container_port   = 80
  }
  
  lifecycle {
    ignore_changes = [desired_count]
  }
  enable_ecs_managed_tags = true
  force_new_deployment    = true
  launch_type = "EC2"
  depends_on  = [aws_lb_listener.web-listener]
}

##############################################################
# AWS CloudWatch
# Description: It will contain all logs for the container 
# and it's useful to see what's wrong with the containers 
# if things are not working as expected.
##############################################################
resource "aws_cloudwatch_log_group" "log_group" {
  name = "/ecs/frontend-container"
  tags = {
    "env"       = "dev"
    "createdBy" = "servian"
  }
}

resource "aws_cloudwatch_log_group" "webdb_log_group" {
  name = "/ecs/webdb-container"
  tags = {
    "env"       = "dev"
    "createdBy" = "servian"
  }
}

resource "aws_cloudwatch_log_group" "db_log_group" {
  name = "/ecs/db-container"
  tags = {
    "env"       = "dev"
    "createdBy" = "servian"
  }
}


