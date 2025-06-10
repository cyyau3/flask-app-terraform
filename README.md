# AWS Infrastructure with Terraform – Flask App Deployment

This project provisions the full AWS infrastructure required to host a Flask-based expense tracker web app using Terraform. It includes EC2, RDS, and secure networking components, designed using Infrastructure as Code (IaC) principles.

---

## What It Builds

- **Amazon VPC** with public and private subnets
- **EC2 instance** (Linux) in public subnet, for app hosting
- **PostgreSQL RDS instance** in private subnet
- **Security Groups** to manage access:
  - EC2: HTTP, SSH (restricted), and app port
  - RDS: Accepts traffic only from EC2
- **IAM Role** attached to EC2 for CloudWatch log publishing
- **CloudWatch Agent** for logging and metrics

---

## How to Use

### 1. Clone this repo
```bash
git clone https://github.com/cyyau3/flask-app-terraform.git
cd flask-app-terraform

### 2. Create a terraform.tfvars file
This file should contain your custom values:
```hcl
my_ip_cidr = "your_public_ip/32"
db_name     = "database_name"
db_username = "your_username"
db_password = "your_db_password"
```
Never commit this file to version control. An example (terraform.tfvars.example) is provided.
Note: You can use the included example-update-ip.sh script to automatically update your current public IP (my_ip_cidr) each time you run Terraform. This helps ensure your SSH access rules are always up to date without manual edits.

### 3. Initialize and Apply Terraform
```bash
terraform init
terraform plan
terraform apply
```

### 4. Destroy Resources (Optional) 
```bash
terraform destroy
```

## Security Practices
•	`.tfvars`, `.tfstate`, and `.pem` files are ignored via `.gitignore`
•	All resource access is tightly scoped via IAM roles and Security Groups
•	Sensitive data is passed via variables, not hardcoded

## File Structure Overview
```
.
├── provider.tf
├── ec2.tf
├── rds.tf
├── vpc.tf
├── cloudwatch.tf
├── security-group.tf
├── variables.tf
├── output.tf
├── data.tf
├── terraform.tfvars.example
├── example-update-ip.sh
└── .gitignore
```