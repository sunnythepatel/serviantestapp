# ServianApp
My take on Servian Take Home Project

I have done using two deployment firstly with creating a dev environment locally using Vagrant as a devops you tend to provide developer the same environement you will be deploying. Secondly with using ecs-ec2 cluster and rds postgre database deployment.

#### 1. Vagrant Deployment
   To deploy locally using vagrant go [here](Vagrant/Readme.md)

#### 2. ECS-EC2 Cluster with RDS Postgres DB Deployment

aws s3api create-bucket --bucket serviantestbucket --region ap-southeast-2 --create-bucket-configuration LocationConstraint=ap-southeast-2

terraform plan -var="username=postgres" -var="password=password123"  -auto-approve

terraform apply -var="username=postgres" -var="password=password123"  -auto-approve

aws s3 rb s3://bucket-name --force  
aws autoscaling delete-auto-scaling-group --auto-scaling-group-name my-asg --force-delete