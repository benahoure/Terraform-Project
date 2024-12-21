# Terraform AWS Project

## Project Overview
This project provisions a highly available AWS infrastructure using Terraform. The infrastructure includes the following resources:

1. Virtual Private Cloud (VPC)
2. Public and private subnets
3. Internet Gateway
4. Route tables and associations
5. Security groups
6. Application Load Balancer (ALB)
7. Auto Scaling Group with Launch Template

The infrastructure is designed for a web application with scalable and secure components.

---

## Prerequisites

Before starting, ensure you have the following installed on your machine:

1. [Terraform](https://www.terraform.io/downloads.html) (version >= 1.0.0)
2. AWS CLI ([installation guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html))
3. An AWS account with programmatic access credentials

---

## Setup Instructions

### 1. Clone the Repository
```bash
git clone <repository-url>
cd <repository-directory>
```

### 2. Configure AWS Credentials
Export your AWS credentials or configure them using the AWS CLI:
```bash
aws configure
```

### 3. Initialize Terraform
Run the following command to initialize Terraform and download necessary providers:
```bash
terraform init
```

### 4. Review and Update Variables
Modify `variables.tf` or provide a `terraform.tfvars` file to customize the project. Example variables include:

- `vpc_cidr`
- `public_subnet_cidrs`
- `private_subnet_cidrs`
- `tags`

### 5. Validate the Configuration
Ensure the configuration files are valid:
```bash
terraform validate
```

### 6. Plan the Deployment
View the resources Terraform will create:
```bash
terraform plan
```

### 7. Deploy the Infrastructure
Apply the configuration to provision the resources:
```bash
terraform apply
```

---

## Resources Provisioned

### **1. VPC**
- Configures a Virtual Private Cloud (VPC) with CIDR specified in `variables.tf`.
- [Terraform AWS VPC Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)

### **2. Subnets**
- Public and private subnets spanning multiple availability zones.
- [Terraform AWS Subnet Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)

### **3. Internet Gateway**
- Provides internet connectivity to public subnets.
- [Terraform AWS Internet Gateway Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway)

### **4. Route Tables and Associations**
- Configures route tables for public and private subnets.
- [Terraform AWS Route Table Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)

### **5. Security Groups**
- Security group for ALB (allowing HTTPS traffic).
- Security group for EC2 instances (allowing HTTP traffic).
- [Terraform AWS Security Group Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)

### **6. Application Load Balancer (ALB)**
- Distributes incoming traffic to EC2 instances.
- [Terraform AWS Load Balancer Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb)

### **7. Auto Scaling Group with Launch Template**
- Ensures EC2 instances scale based on demand.
- [Terraform AWS Auto Scaling Group Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group)

---
## My Advice, don't forget to clean up because AWS charge for resources!
## How to Destroy the Infrastructure

To remove all resources created by Terraform:
```bash
terraform destroy
```

---

## Notes

- Ensure the AWS region specified is available for all resources.
- Use proper IAM permissions for the AWS credentials used.

---

## Documentation Links

1. [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest)
2. [Terraform Documentation](https://www.terraform.io/docs/index.html)
