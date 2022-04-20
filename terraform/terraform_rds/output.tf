output "vpc_id" {
  value = aws_vpc.default.id
}

output "public_subnets" {
  value = [aws_subnet.public__a.availability_zone,aws_subnet.public__b.availability_zone,aws_subnet.public__c.availability_zone]
}

output "postgres_endpoint" {
    value = aws_db_instance.default.endpoint
}
