# StartTech Infrastructure

This repository contains all the infrastructure code for the StartTech application, provisioned using Terraform on AWS.

## Infrastructure Overview

- VPC with public and private subnets
- EC2 instance with Auto Scaling Group for the backend API
- Application Load Balancer for traffic distribution
- S3 bucket for frontend static hosting
- CloudFront distribution for global content delivery
- ElastiCache Redis cluster for caching
- AWS ECR for Docker image storage
- CloudWatch Log Groups for centralized logging
- IAM roles and policies for secure access
- Security Groups for network access control

## Repository Structure

```
starttech-infra/
├── .github/
│   └── workflows/
│       └── infrastructure-deploy.yml
├── terraform/
│   ├── main.tf
│   ├── outputs.tf
│   ├── variables.tf
│   └── modules/
│       ├── networking/
│       ├── compute/
│       ├── storage/
│       └── monitoring/
├── monitoring/
├── scripts/
└── README.md
```

## Deployment

### Prerequisites
- Terraform installed
- AWS CLI configured
- AWS credentials with necessary permissions

### Steps

1. Clone the repository
2. Navigate to the terraform folder
3. Initialize Terraform:
```bash
terraform init
```
4. Review the plan:
```bash
terraform plan
```
5. Apply the infrastructure:
```bash
terraform apply
```

## Live Outputs

- Frontend URL: http://muchtodo-frontend-dev.s3-website-us-east-1.amazonaws.com
- Backend ALB: http://muchtodo-alb-final-425877782.us-east-1.elb.amazonaws.com
- CloudFront: https://dzbg5w9pb03gl.cloudfront.net

## Modules

- networking: VPC, subnets, internet gateway, route tables
- compute: EC2, Auto Scaling Group, ALB, security groups
- storage: S3 bucket, CloudFront distribution
- monitoring: CloudWatch log groups, alarms

