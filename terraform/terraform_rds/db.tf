###########################################################
# AWS RDS INSTANCE
# `vpc` is created using 3-subnets, route table 
# and route table association
###########################################################
resource "aws_db_instance" "default" {
  allocated_storage         = 5
  max_allocated_storage     = 20
  backup_window             = "03:00-04:00"
  ca_cert_identifier        = "rds-ca-2019"
  db_subnet_group_name      = "${aws_db_subnet_group.default.name}"
  engine_version            = "13.4"
  engine                    = "postgres"
  final_snapshot_identifier = "final-snapshot"
  identifier                = "production"
  instance_class            = "db.t3.micro"
  maintenance_window        = "sun:08:00-sun:09:00"
  name                      = "todo_production"
  parameter_group_name      = "default.postgres13"
  port                      = 5432
  password                  = var.password
  username                  = var.username
  skip_final_snapshot       = true
  publicly_accessible       = true
  vpc_security_group_ids    = ["${aws_security_group.db_instance.id}"]
  multi_az                  = true
  backup_retention_period   = 2
  
}




