# serviantestapp
Servian Take Home Project

aws s3api create-bucket --bucket serviantestbucket --region ap-southeast-2 --create-bucket-configuration LocationConstraint=ap-southeast-2

terraform plan -var="username=postgres" -var="password=password123"  -auto-approve

terraform apply -var="username=postgres" -var="password=password123"  -auto-approve

aws s3 rb s3://bucket-name --force  
aws autoscaling delete-auto-scaling-group --auto-scaling-group-name my-asg --force-delete