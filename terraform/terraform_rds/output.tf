output "vpc_id" {
  value = aws_vpc.default.id
}

output "public_subnets" {
  value = [aws_subnet.public__a,aws_subnet.public__b,aws_subnet.public__c]
}

output "postgres_endpoint" {
    value = aws_db_instance.default.endpoint
}

# output "ec2instance" {
#   value = aws_instance.project-iac.public_ip
# }