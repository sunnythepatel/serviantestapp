## Vagrant Docker Development VM

This Readme.md file contains instructions to install and configure the AWS Development ECS-EC2 VMs with RDS.

Creating a simple infrastructure using Terraform and AWS cloud provider. It consists of:
- Virtual Private Cloud (VPC) with 3 public subnets in 3 availability zones
- Elastic Container Service (ECS)
- Application Load Balancer (ALB)
- Managed Relational Database Service (RDS)
- S3 Bucket
- CloudWatch
- Auto Scaling Groups (ASG)


### How do i use it? 

#### 1. Manual Deployment

##### Step 1. Pre-requisite
1. Download Terraform
   https://www.terraform.io/downloads 

   The version the code was tested and created on
```
   terraform --version
    Terraform v1.1.8
    on darwin_amd64
    + provider registry.terraform.io/hashicorp/aws v3.75.1
```
2. Download aws cli
   https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html 

##### Step 2. Configure AWS using AWS CLI or Environment Variable

a. Using Environment Variable
```
$ export AWS_SECRET_ACCESS_KEY=...
$ export AWS_ACCESS_KEY_ID=..
$ export AWS_DEFAULT_REGION=ap-southeast-2
```

b. Using AWS CLI
Provide your AWS Access Key ID, AWS Secret Access Key and Default region name as `ap-southeast-2`
```
$> aws configure
```
I have kept the region as Sydney (ap-southeast-2) because I think the app should be as closer to the customer/user. We can further make our code dynamic by adding variable.
##### Step 3. Create a S3 bucket
```
aws s3api create-bucket --bucket serviantestbucket --region ap-southeast-2 --create-bucket-configuration LocationConstraint=ap-southeast-2
```
We need to create a S3 bucket to store ```terraform.tfstate``` in S3 bucket. I am not sure but using terraform I wasn't able to create it automatically somehow so went with aws api.
##### Step 4. How to create the RDS infrastructure?
This implies that you have already AWS account and Terraform CLI installed. We will first deploy a RDS Postgre DB as we need to create a db for the app so the thought process is to use a seperate production db where we can store all the resources. Once the RDS Postgres DB instance is launched we will get an endpoint at the output section. The endpoint should look like `**.**.ap-southeast-2.rds.amazonaws.com:5432` we will copy the endpoint without the port and semicolon as the input variable for the ECS-EC2 instance. It should look like this `**.**.ap-southeast-2.rds.amazonaws.com`.
1.  Go to `cd terraform/terraform_rds`
2. Edit the `rds.tfvars` file and provide the username and password for the postgres. The file can be found in `terraform/terraform_rds/rds.tfvars`.
3. Run `terraform init`
4. Run `terraform plan -var-file="rds.tfvars" -auto-approve`
5. Run `terraform apply -var-file="rds.tfvars" -auto-approve`
It will take approximate 12 mins to create all rds resources.

##### Step 5. How to create the ECS-EC2 infrastructure?
We will deploy all the resources for ECS-EC2 instances and deploy the app. All the details of the app is mentioned in `container_definitions` which can be found in ecs.tf. We are also doing few more things as you will find multiple containers. Let's talk in details about each container we are deploying:
a. db container: In this what we are doinng is basically fixing an AWS RDS issue https://github.com/servian/TechChallengeApp/issues/29 which is pq: permission denied for tablespace pg_default as it's owned by rds_admin and nott by the user you mentioned while deploying. The container just connect the RDS instance and run an alter command `ALTER TABLESPACE pg_default OWNER TO postgres` which give the user postgres in this case so we can run updatedb container and feed the data in the RDS DB instance. Once it's run the command the container goes to exit state. The best way to fix this issue is to do `local_exec` once the RDS resource is created or it can also be done using `remote-exec` on an AWS instance. 
b. myapp container: In this we run the servian techchallengeapp so we can access it using `alb_dns`.
c. webdb container: In this we run updatedb command so we can feed the data to RDS Postgres DB. Let's start now with deploying the resources.
1. Copy the host part of the RDS Endpoint without port which should look like this `**.**.ap-southeast-2.rds.amazonaws.com`.
2. Go to `cd terraform/terraform_web`
3. Edit the `web.tfvars` file and provide the host, username and password for the postgres, cluster_name and key_name for the ecs-ec2 instance. The file can be found in `terraform/terraform_web/web.tfvars`. 
Note: Assuming you already have a ssh public key on ec2 key pairs in ap-southeast-2 region.
4. Run `terraform init`
5. Run `terraform plan -var-file="web.tfvars" -auto-approve`
6. Run `terraform apply -var-file="web.tfvars" -auto-approve`
It will take about 5 minutes to provision all resources.

Once all the resources are up copy the alb_dns `test-ecs-lb-****.ap-southeast-2.elb.amazonaws.com` which you see in output and paste in browser to see the deployed app.
## Step 6. How to delete the infrastructure?
1. Terminate ec2 instances
2. Delete ASG manually only if the terraform_webapp destroy fails.
3. `cd terraform/terraform_webapp` and Run `terraform destroy -var-file="web.tfvars" -auto-approve`
4. `cd terraform/terraform_rds` and Run `terraform destroy -var-file="rds.tfvars" -auto-approve`
5. Delete s3 bucket `aws s3 rb s3://serviantestbucket --force --profile default` 
#### 2. GitHub Actions Deployment

2a. Using Github Actions Ubuntu Runner
    It's basically running on Ubuntu and it's run only if there is a change in the code in terraform folder in either branch terraformdev or main. You need to set the Repository secrets in github to use the ci. You can follow this to add https://stackoverflow.com/questions/58643905/how-aws-credentials-works-at-github-actions#:~:text=To%20get%20access%20to%20secrets,step%20as%20an%20env%20var.&text=In%20your%20case%20you%20will,for%20both%20AWS_ACCESS_KEY_ID%20and%20AWS_SECRET_ACCESS_KEY%20. 
    At the moment, I have commented out the Terraform Plan and Terraform Apply which can be used to test and deploy using github actions and run using -var command or-var-file command.

2b. Using Self-hosted Runner
  a. Please using these steps to create one https://docs.github.com/en/actions/hosting-your-own-runners/adding-self-hosted-runners 

  b. Once, done just head to ```.github/terraform_ci.yml``` and look for jobs section and replace it with runs-on: self-hosted

```
jobs:
vagrant-up:
    runs-on: self-hosted
```
  You can follow these steps to see the correct way https://docs.github.com/en/actions/hosting-your-own-runners/using-self-hosted-runners-in-a-workflow 







aws s3 rb s3://bucket-name --force  
aws autoscaling delete-auto-scaling-group --auto-scaling-group-name my-asg --force-delete