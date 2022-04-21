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

##### Pre-requisite
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

##### Configure AWS using AWS CLI or Environment Variable

a. Using Environment Variable
```
$ export AWS_SECRET_ACCESS_KEY=...
$ export AWS_ACCESS_KEY_ID=..
$ export AWS_DEFAULT_REGION=ap-southeast-2
```

b. Using AWS CLI
Provide your AWS Access Key ID, AWS Secret Access Key and Default region name as ap-southeast-2
```
$> aws configure
```
I have kept the region as Sydney (ap-southeast-2) because I think the app should be as closer to the customer/user. We can further make our code dynamic by adding variable.
##### Create a S3 bucket
```
aws s3api create-bucket --bucket serviantestbucket --region ap-southeast-2 --create-bucket-configuration LocationConstraint=ap-southeast-2
```
We need to create a S3 bucket to store ```terraform.tfstate``` in S3 bucket. I am not sure but using terraform I wasn't able to create it automatically somehow so went with aws api.
##### How to create the RDS infrastructure?
This example implies that you have already AWS account and Terraform CLI installed.
1. cd terraform
2. terraform init
3. terraform plan
4. terraform apply
   Approximate 12 mins to create all resources

Note: it can take about 5 minutes to provision all resources
##### How to create the ECS-EC2 infrastructure?
This example implies that you have already AWS account and Terraform CLI installed.
1. cd terraform
2. terraform init
3. terraform plan
4. terraform apply

Note: it can take about 5 minutes to provision all resources.
## How to delete the infrastructure?
1. Terminate instances
2. `cd terraform/terraform_webapp` and Run `terraform destroy`
2. `cd terraform/terraform_rds` and Run `terraform destroy`
#### 2. GitHub Actions Deployment
 
2a. Using GihubActions Ubuntu Runner
    It's basically running on Ubuntu and it's run only if there is a change in the code in terraform folder in either branch terraformdev or main.

2b. Using Self-hosted Runner
  a. Please using these steps to create one https://docs.github.com/en/actions/hosting-your-own-runners/adding-self-hosted-runners 

  b. Once, done just head to ```.github/terraform_ci.yml``` and look for jobs section and replace it with runs-on: self-hosted

```
jobs:
vagrant-up:
    runs-on: self-hosted
```
  You can follow these steps to see the correct way https://docs.github.com/en/actions/hosting-your-own-runners/using-self-hosted-runners-in-a-workflow 





aws s3api create-bucket --bucket serviantestbucket --region ap-southeast-2 --create-bucket-configuration LocationConstraint=ap-southeast-2

terraform plan -var="username=postgres" -var="password=password123"  -auto-approve

terraform apply -var="username=postgres" -var="password=password123"  -auto-approve

aws s3 rb s3://bucket-name --force  
aws autoscaling delete-auto-scaling-group --auto-scaling-group-name my-asg --force-delete