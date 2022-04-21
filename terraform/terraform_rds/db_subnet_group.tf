####################################################################
# DB Subnet Group
# Description: Here we add 3 db subnet for the RDS instance. 
#####################################################################
resource "aws_db_subnet_group" "default" {
  name = "db-subnet-group"
  
  subnet_ids = [
    aws_subnet.public__a.id,
    aws_subnet.public__b.id,
    aws_subnet.public__c.id
  ]


  tags = {
    Env  = "production"
    Name = "db-subnet-group"
  }
}