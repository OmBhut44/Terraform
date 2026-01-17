# 🚀 Terraform AWS Infrastructure Automation

A complete beginner-to-professional Terraform project that demonstrates how to provision AWS infrastructure using Infrastructure as Code (IaC) with security best practices.

This repository is designed to help developers, students, and DevOps engineers understand how to build, deploy, and manage AWS resources using Terraform in a clean and scalable way.

---

## 📑 Table of Contents

- [Project Overview](#-project-overview)
- [Technologies Used](#-technologies-used)
- [Prerequisites](#-prerequisites)
- [Remote Infrastructure Configuration](#️-remote-infrastructure-configuration)
  - [Location](#-location)
  - [Purpose](#-purpose)
  - [Infrastructure Components](#️-infrastructure-components)
  - [Files Structure](#-files-structure)
  - [How It Works](#-how-it-works)
  - [Configuration Details](#️-configuration-details)
  - [Deployment Steps](#-deployment-steps)
  - [Security Best Practices](#️-security-best-practices)
  - [Benefits of Remote Backend](#-benefits-of-remote-backend)
- [AWS IAM User Setup](#-aws-iam-user-setup-security-first-approach)
  - [Step 1: Create IAM User](#step-1--create-a-new-iam-user)
  - [Step 2: Assign Permissions](#step-2--assign-permissions)
  - [Step 3: Generate Access Keys](#step-3--generate-access-keys)
  - [Step 4: Configure AWS CLI](#step-4--configure-aws-cli)

---

## 📌 Project Overview

This project uses Terraform to automate AWS infrastructure provisioning with a production-ready remote backend configuration.

It demonstrates how to:

✅ Configure AWS provider  
✅ Manage AWS resources using Terraform  
✅ Implement remote backend with S3 and DynamoDB  
✅ Set up state locking for team collaboration  
✅ Follow DevOps & cloud security best practices  
✅ Implement Infrastructure as Code  
✅ Build repeatable cloud deployments  

This repository is beginner-friendly and suitable for real-world learning, with advanced features like remote state management for production environments.

---

## 🧩 Technologies Used

- **Terraform** - Infrastructure as Code (IaC) tool
- **AWS Services**:
  - EC2 (Elastic Compute Cloud)
  - IAM (Identity and Access Management)
  - Security Groups
  - S3 (Simple Storage Service) - Remote state storage
  - DynamoDB - State locking mechanism
- **AWS CLI** - Command-line interface for AWS
- **Git & GitHub** - Version control and collaboration

---

## 📦 Prerequisites

Before getting started, make sure you have:

- An AWS account
- Terraform installed
- AWS CLI installed
- Git installed
- IAM user with programmatic access

---

## 🗂️ Remote Infrastructure Configuration

This project includes a **Remote Infrastructure** setup that implements Terraform's remote backend using AWS S3 and DynamoDB. This is a production-ready approach for managing Terraform state files securely and enabling team collaboration.

### 📍 Location

The remote infrastructure configuration is located in the `remote infra/` directory.

### 🎯 Purpose

The remote infrastructure setup serves two critical purposes:

1. **State Storage**: Securely stores Terraform state files in an S3 bucket
2. **State Locking**: Prevents concurrent modifications using DynamoDB for state locking

### 🏗️ Infrastructure Components

#### 1. **AWS S3 Bucket** (`s3.tf`)
- **Bucket Name**: `om-tf-state-bucket`
- **Purpose**: Stores Terraform state files remotely
- **Benefits**:
  - Centralized state management
  - Version history and backup capabilities
  - Secure storage in AWS cloud
  - Enables team collaboration on infrastructure

#### 2. **AWS DynamoDB Table** (`dynamodb.tf`)
- **Table Name**: `om-tf-state-table`
- **Primary Key**: `LockID` (String)
- **Billing Mode**: `PAY_PER_REQUEST` (On-demand)
  - Cost-effective for intermittent use
  - No upfront costs or capacity planning required
- **Purpose**: Provides state locking mechanism
- **Benefits**:
  - Prevents race conditions during concurrent operations
  - Ensures only one Terraform operation runs at a time
  - Prevents state corruption from simultaneous modifications

#### 3. **Remote Backend Configuration** (`terraform.tf`)
- **Backend Type**: Remote (S3 + DynamoDB)
- **Configuration**:
  ```hcl
  backend "remote" {
    bucket         = "om-tf-state-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "om-tf-state-table"
  }
  ```
- **Region**: `us-east-2` (Ohio)
- **State File Key**: `terraform.tfstate`

### 📋 Files Structure

```
remote infra/
├── terraform.tf          # Remote backend configuration
├── provider.tf           # AWS provider setup (us-east-2 region)
├── s3.tf                 # S3 bucket for state storage
└── dynamodb.tf           # DynamoDB table for state locking
```

### 🔄 How It Works

1. **State Storage Flow**:
   - Terraform writes state to S3 bucket (`om-tf-state-bucket`)
   - State file is stored with key `terraform.tfstate`
   - All state changes are tracked in the S3 bucket

2. **State Locking Flow**:
   - Before any Terraform operation, a lock is created in DynamoDB
   - Lock contains a unique `LockID` identifier
   - Other operations wait until the lock is released
   - After operation completes, the lock is automatically removed

3. **Team Collaboration**:
   - Multiple team members can work on the same infrastructure
   - State locking prevents conflicts and corruption
   - All changes are centralized in the remote state

### ⚙️ Configuration Details

#### Provider Configuration
- **Provider**: AWS
- **Version**: `6.28.0` (HashiCorp AWS Provider)
- **Region**: `us-east-2` (Ohio)

#### S3 Bucket Configuration
- **Bucket Name**: `om-tf-state-bucket`
- **Tagged**: Yes (for resource identification)

#### DynamoDB Table Configuration
- **Table Name**: `om-tf-state-table`
- **Partition Key**: `LockID` (String type)
- **Billing Mode**: `PAY_PER_REQUEST`
  - Charges only for actual read/write operations
  - No minimum capacity costs
  - Ideal for development and testing environments

### 🚀 Deployment Steps

1. **Navigate to Remote Infra Directory**:
   ```bash
   cd "remote infra"
   ```

2. **Initialize Terraform**:
   ```bash
   terraform init
   ```

3. **Plan Infrastructure Changes**:
   ```bash
   terraform plan
   ```

4. **Apply Infrastructure**:
   ```bash
   terraform apply
   ```

5. **Verify Resources**:
   - Check S3 bucket creation in AWS Console
   - Verify DynamoDB table creation
   - Confirm backend configuration is active

### 🛡️ Security Best Practices

- ✅ State files stored securely in S3 (not in local directory)
- ✅ State locking prevents concurrent modifications
- ✅ S3 bucket can be configured with encryption
- ✅ DynamoDB table uses secure access patterns
- ✅ IAM policies can restrict access to state bucket

### 💡 Benefits of Remote Backend

| Feature | Local Backend | Remote Backend (This Setup) |
|---------|--------------|------------------------------|
| State Storage | Local file | S3 bucket (cloud) |
| State Locking | ❌ Not available | ✅ DynamoDB |
| Team Collaboration | ❌ Difficult | ✅ Seamless |
| State Backup | Manual | Automatic (S3 versioning) |
| Security | Local file risk | Cloud-secured |
| Scalability | Limited | High |

### ⚠️ Important Notes

- **State File Security**: The state file may contain sensitive data. Ensure S3 bucket has proper access controls.
- **Lock Management**: If a lock is stuck, it can be manually removed from DynamoDB (use with caution).
- **Backend Migration**: Switching to remote backend requires running `terraform init -migrate-state` for existing state.
- **Cost Optimization**: DynamoDB `PAY_PER_REQUEST` mode is cost-effective for low-frequency operations.

### 📚 Additional Resources

- [Terraform Remote Backend Documentation](https://www.terraform.io/docs/language/settings/backends/s3.html)
- [AWS S3 Best Practices](https://docs.aws.amazon.com/AmazonS3/latest/userguide/security-best-practices.html)
- [DynamoDB On-Demand Billing](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/HowItWorks.ReadWriteCapacityMode.html#HowItWorks.OnDemand)

---

# 🔐 AWS IAM User Setup (Security First Approach)

> ⚠️ Important Security Note  
> For learning and testing, you may grant **AdministratorAccess temporarily**.  
> In real production projects, always assign permissions based on actual usage (least privilege principle).

---

## Step 1 — Create a New IAM User

1. Login to AWS Console  
2. Go to **IAM → Users → Create user**  
3. Enter username:
4. Select access type:

---

## Step 2 — Assign Permissions

For learning and practice, attach:


⚠️ Do NOT use AdministratorAccess in production.

### Recommended Permission Model

| Use Case | Policy |
|---------|--------|
| Learning Terraform | AdministratorAccess (temporary) |
| EC2 only | AmazonEC2FullAccess |
| S3 only | AmazonS3FullAccess |
| Production Terraform | Custom IAM Policy |

---

## Step 3 — Generate Access Keys

Go to: IAM → Users → terraform-user → Security Credentials → Create Access Key


Save securely:
- Access Key ID  
- Secret Access Key  

⚠️ The secret key is shown only once.

---

## Step 4 — Configure AWS CLI

```bash
aws configure

AWS Access Key ID:     <your-access-key>
AWS Secret Access Key: <your-secret-key>
Default region name:   ap-south-1
Default output format: json
