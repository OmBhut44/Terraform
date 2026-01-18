# 🚀 Terraform AWS Infrastructure Automation

A complete beginner-to-professional Terraform project that demonstrates how to provision AWS infrastructure using Infrastructure as Code (IaC) with security best practices.

This repository is designed to help developers, students, and DevOps engineers understand how to build, deploy, and manage AWS resources using Terraform in a clean and scalable way.

---

## 📑 Table of Contents

- [Project Overview](#-project-overview)
- [Technologies Used](#-technologies-used)
- [Prerequisites](#-prerequisites)
- [Remote Infrastructure Configuration](#️-remote-infrastructure-configuration)
  - [What is Remote Backend?](#-what-is-remote-backend)
  - [Why Do We Need Remote Backend?](#-why-do-we-need-remote-backend)
  - [Project Structure](#-project-structure)
  - [Detailed File Breakdown](#-detailed-file-breakdown)
    - [File 1: terraform.tf - Backend Configuration](#file-1-terraformtf---backend-configuration)
    - [File 2: provider.tf - AWS Provider Setup](#file-2-providertf---aws-provider-setup)
    - [File 3: s3.tf - State Storage Bucket](#file-3-s3tf---state-storage-bucket)
    - [File 4: dynamodb.tf - State Locking Table](#file-4-dynamodbtf---state-locking-table)
  - [How Everything Works Together](#-how-everything-works-together)
  - [Step-by-Step Workflow](#-step-by-step-workflow)
  - [Complete Deployment Guide](#-complete-deployment-guide)
  - [Understanding State Management](#-understanding-state-management)
  - [Benefits of Remote Backend](#-benefits-of-remote-backend)
  - [Security Best Practices](#-security-best-practices)
  - [Troubleshooting Common Issues](#-troubleshooting-common-issues)
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

This project includes a comprehensive **Remote Infrastructure** setup that implements Terraform's remote backend using AWS S3 and DynamoDB. This is a production-ready approach for managing Terraform state files securely and enabling seamless team collaboration.

### 📍 Location

The remote infrastructure configuration is located in the `remote infra/` directory within this project.

---

### 💡 What is Remote Backend?

**Remote Backend** is a Terraform feature that stores your infrastructure state file in a remote location (like AWS S3) instead of keeping it locally on your machine. This solves several critical problems:

- **Problem 1**: If your local machine crashes or the state file gets deleted, you lose all information about your infrastructure
- **Problem 2**: When multiple team members work on the same infrastructure, they need to share the state file manually, which leads to conflicts
- **Problem 3**: There's no way to prevent two people from modifying the infrastructure at the same time, causing corruption

**Solution**: Remote Backend stores the state in a centralized location (S3) and uses DynamoDB to lock it during operations, ensuring only one person can make changes at a time.

---

### 🎯 Why Do We Need Remote Backend?

Imagine this scenario:
- You create an EC2 instance using Terraform
- The state file is stored locally on your computer
- Your teammate also wants to modify the same infrastructure
- Both of you run `terraform apply` at the same time
- **Result**: Conflicting changes, corrupted state, or infrastructure inconsistencies

**Remote Backend solves this by:**
1. **Centralized Storage**: Everyone uses the same state file stored in S3
2. **State Locking**: DynamoDB ensures only one operation happens at a time
3. **Team Collaboration**: Multiple developers can work together safely
4. **Backup & Recovery**: State is always backed up in AWS cloud

---

### 📋 Project Structure

```
remote infra/
├── terraform.tf          # Configures remote backend and provider requirements
├── provider.tf           # Sets up AWS provider with region configuration
├── s3.tf                 # Creates S3 bucket to store Terraform state files
└── dynamodb.tf           # Creates DynamoDB table for state locking mechanism
```

---

### 📖 Detailed File Breakdown

Let's understand what each file does and why it's essential:

#### **File 1: terraform.tf - Backend Configuration**

This is the **most important file** in the remote infra setup. It tells Terraform where to store the state file and how to lock it.

**Full Code:**
```hcl
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.28.0"
    }
  }

  # Configure the Remote Backend -> it is done in s3.tf and dynamodb.tf files 
  # because we have created s3 bucket and dynamodb table there
  backend "remote" {
    bucket = "om-tf-state-bucket"
    key    = "terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "om-tf-state-table"
  }
}

# Translation: My Terraform will use the remote backend which will use 
# om-tf-state-bucket S3 bucket and om-tf-state-table DynamoDB table 
# so that my Terraform state file gets stored there and also gets locked 
# so that multiple people cannot modify the same state file simultaneously.
```

**Line-by-Line Explanation:**

1. **`required_providers` block:**
   - Specifies that we need the AWS provider
   - `source = "hashicorp/aws"` - Official AWS provider from HashiCorp
   - `version = "6.28.0"` - Specific version to ensure consistency across environments

2. **`backend "remote"` block:**
   - **`bucket = "om-tf-state-bucket"`**: Where to store the state file (S3 bucket name)
   - **`key = "terraform.tfstate"`**: The filename/path for the state file inside the bucket
   - **`region = "us-east-2"`**: AWS region where S3 bucket and DynamoDB table are located
   - **`dynamodb_table = "om-tf-state-table"`**: Table name used for state locking

**Why This Matters:**
- Without this configuration, Terraform stores state locally (risky!)
- This ensures all state operations go through AWS, making it accessible to your team
- The backend must be configured before you create the S3 bucket and DynamoDB table

---

#### **File 2: provider.tf - AWS Provider Setup**

This file configures the AWS provider, telling Terraform which cloud region to use.

**Full Code:**
```hcl
provider "aws" {
  region = "us-east-2"
}
```

**Explanation:**
- **`provider "aws"`**: Specifies we're using the AWS cloud provider
- **`region = "us-east-2"`**: Sets the default AWS region to Ohio, USA
  - All resources will be created in this region unless specified otherwise
  - S3 bucket and DynamoDB table must be in the same region for the backend to work

**Why This Matters:**
- Consistency: All resources created in the same region reduce latency and costs
- Region Selection: `us-east-2` (Ohio) is often chosen for cost-effectiveness
- Backend Requirement: The backend bucket and table must be in this same region

---

#### **File 3: s3.tf - State Storage Bucket**

This file creates the S3 bucket that will store all Terraform state files.

**Full Code:**
```hcl
resource "aws_s3_bucket" "remote_s3" {
  bucket = "om-tf-state-bucket"

  tags = {
    Name = "om-tf-state-bucket"
  }
}
```

**Line-by-Line Explanation:**

1. **`resource "aws_s3_bucket" "remote_s3"`:**
   - Creates an AWS S3 bucket resource
   - `remote_s3` is the resource identifier used within Terraform code

2. **`bucket = "om-tf-state-bucket"`:**
   - The globally unique bucket name (must be unique across all AWS accounts)
   - This is the bucket referenced in `terraform.tf` backend configuration

3. **`tags` block:**
   - Adds metadata tags to the bucket
   - `Name` tag helps identify the bucket in AWS Console
   - Useful for resource organization and cost tracking

**What Happens:**
- When you run `terraform apply`, this creates an S3 bucket in AWS
- Terraform will store the `terraform.tfstate` file inside this bucket
- The state file contains all information about your infrastructure (what exists, what was created, IDs, etc.)

**Important Notes:**
- ⚠️ **Bucket names must be globally unique** - If `om-tf-state-bucket` already exists, you'll need to change it
- 🔒 **Secure**: Consider enabling versioning and encryption (advanced configurations)
- 💰 **Cost**: S3 storage is very cheap, typically less than $1/month for small state files

---

#### **File 4: dynamodb.tf - State Locking Table**

This file creates a DynamoDB table that prevents multiple people from modifying infrastructure simultaneously.

**Full Code:**
```hcl
resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "om-tf-state-table"
  # billing_mode   = "PROVISIONED" # Once created, it keeps billing for the whole month
  billing_mode   = "PAY_PER_REQUEST" # This will bill only when used
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S" # S means String
  }
  
  tags = {
    Name = "om-tf-state-table" 
  }
}
```

**Detailed Explanation:**

1. **`resource "aws_dynamodb_table" "basic-dynamodb-table"`:**
   - Creates a DynamoDB NoSQL database table
   - `basic-dynamodb-table` is the internal Terraform resource name

2. **`name = "om-tf-state-table"`:**
   - The actual table name in AWS
   - This name is referenced in `terraform.tf` backend configuration

3. **`billing_mode = "PAY_PER_REQUEST"`:**
   - **Why not PROVISIONED?** As the comment explains, PROVISIONED mode charges you for the entire month even if you don't use the table
   - **PAY_PER_REQUEST** means you only pay when the table is actually used (read/write operations)
   - **Cost savings**: For low-frequency operations, this is much cheaper (often $0.25 per million requests)
   - Perfect for development and intermittent use

4. **`hash_key = "LockID"`:**
   - Sets the primary key (partition key) for the table
   - This key uniquely identifies each lock entry
   - When Terraform needs to lock, it writes a record with a unique LockID

5. **`attribute` block:**
   - Defines the schema for the table
   - `name = "LockID"`: The attribute name
   - `type = "S"`: String data type (DynamoDB types: S=String, N=Number, B=Binary)

6. **`tags` block:**
   - Resource tags for identification and organization

**How State Locking Works:**

1. **Before `terraform apply`:**
   - Terraform tries to write a lock record to DynamoDB with a unique `LockID`
   - If successful, it proceeds with the operation
   - If another operation is running, the lock write fails, and Terraform waits

2. **During operation:**
   - The lock remains in DynamoDB, preventing other operations
   - Other team members see: "Error: Error acquiring the state lock"

3. **After completion:**
   - Terraform automatically deletes the lock from DynamoDB
   - Next operation can now proceed

**Real-World Example:**
```
Developer A: terraform apply  →  Locks DynamoDB  →  Modifies infrastructure
Developer B: terraform apply  →  Sees lock       →  Waits...
Developer A: Finishes         →  Releases lock   →  Developer B proceeds
```

---

### 🔄 How Everything Works Together

Here's the complete flow of how these components interact:

```
┌─────────────────────────────────────────────────────────────┐
│                     Developer's Machine                      │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  1. Run: terraform apply                              │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                           │
                           │ (Step 1: Check for lock)
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                    AWS DynamoDB Table                        │
│              (om-tf-state-table)                             │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ LockID: terraform-state-lock-xyz123                  │   │
│  │ Status: LOCKED                                       │   │
│  │ Locked By: Developer A                               │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                           │
                           │ (Step 2: Read current state)
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                    AWS S3 Bucket                             │
│              (om-tf-state-bucket)                            │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ terraform.tfstate                                    │   │
│  │ {                                                    │   │
│  │   "resources": [...],                               │   │
│  │   "outputs": {...}                                  │   │
│  │ }                                                   │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                           │
                           │ (Step 3: Apply changes)
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                    AWS Infrastructure                        │
│  (EC2, S3, DynamoDB, etc.)                                  │
│                                                              │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐                  │
│  │ Resource │  │ Resource │  │ Resource │                  │
│  │    A     │  │    B     │  │    C     │                  │
│  └──────────┘  └──────────┘  └──────────┘                  │
└─────────────────────────────────────────────────────────────┘
                           │
                           │ (Step 4: Update state)
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                    AWS S3 Bucket                             │
│              (Updated terraform.tfstate)                     │
└─────────────────────────────────────────────────────────────┘
                           │
                           │ (Step 5: Release lock)
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                    AWS DynamoDB Table                        │
│                    (Lock removed)                            │
└─────────────────────────────────────────────────────────────┘
```

---

### 📝 Step-by-Step Workflow

When you run `terraform apply` in the `remote infra` directory:

**Step 1: Initialize Backend**
- Terraform checks if the S3 bucket exists
- Verifies DynamoDB table exists
- Sets up connection to remote backend

**Step 2: Acquire Lock**
- Terraform writes a lock entry to DynamoDB
- If lock exists, operation waits or fails
- If successful, proceeds to next step

**Step 3: Read State**
- Terraform downloads `terraform.tfstate` from S3
- Loads current infrastructure state into memory
- Compares with desired state (your `.tf` files)

**Step 4: Calculate Changes**
- Terraform determines what needs to be created/updated/deleted
- Shows you the execution plan

**Step 5: Apply Changes**
- Creates/updates/deletes AWS resources
- Monitors progress and handles errors

**Step 6: Update State**
- Writes updated `terraform.tfstate` back to S3
- State now reflects current infrastructure

**Step 7: Release Lock**
- Deletes lock entry from DynamoDB
- Other operations can now proceed

---

### 🚀 Complete Deployment Guide

Follow these steps to set up and deploy your remote infrastructure:

#### **Prerequisites Check**
Before starting, ensure:
- ✅ AWS CLI is configured (`aws configure`)
- ✅ Terraform is installed (`terraform version`)
- ✅ You have permissions to create S3 buckets and DynamoDB tables

#### **Step 1: Navigate to Directory**
```bash
cd "remote infra"
```

#### **Step 2: Initialize Terraform**
```bash
terraform init
```
**What this does:**
- Downloads AWS provider plugin (version 6.28.0)
- Configures the remote backend
- Sets up local `.terraform` directory

**Expected Output:**
```
Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/aws versions matching "6.28.0"...
- Installing hashicorp/aws v6.28.0...
```

#### **Step 3: Validate Configuration**
```bash
terraform validate
```
**What this does:**
- Checks syntax errors in `.tf` files
- Validates resource configurations

**Expected Output:**
```
Success! The configuration is valid.
```

#### **Step 4: Review Execution Plan**
```bash
terraform plan
```
**What this does:**
- Shows what resources will be created
- Displays estimated changes
- Does NOT actually create anything

**Expected Output:**
```
Plan: 2 to add, 0 to change, 0 to destroy.

# aws_dynamodb_table.basic-dynamodb-table will be created
# aws_s3_bucket.remote_s3 will be created
```

#### **Step 5: Apply Infrastructure**
```bash
terraform apply
```
**What this does:**
- Actually creates the resources in AWS
- Prompts for confirmation (type `yes`)

**Expected Output:**
```
aws_s3_bucket.remote_s3: Creating...
aws_s3_bucket.remote_s3: Creation complete
aws_dynamodb_table.basic-dynamodb-table: Creating...
aws_dynamodb_table.basic-dynamodb-table: Creation complete

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```

#### **Step 6: Verify in AWS Console**
1. **Check S3 Bucket:**
   - Go to AWS Console → S3
   - Find bucket: `om-tf-state-bucket`
   - Verify it exists

2. **Check DynamoDB Table:**
   - Go to AWS Console → DynamoDB
   - Find table: `om-tf-state-table`
   - Verify it exists with `LockID` as partition key

#### **Step 7: Verify State File Location**
```bash
terraform state list
```
**What this does:**
- Lists all resources in the state
- Confirms state is being read from remote backend

**Expected Output:**
```
aws_dynamodb_table.basic-dynamodb-table
aws_s3_bucket.remote_s3
```

---

### 📚 Understanding State Management

#### **What is Terraform State?**
Terraform state is a JSON file that contains:
- List of all resources managed by Terraform
- Resource IDs and attributes
- Relationships between resources
- Output values

**Example State File Structure:**
```json
{
  "version": 4,
  "terraform_version": "1.5.0",
  "resources": [
    {
      "type": "aws_s3_bucket",
      "name": "remote_s3",
      "instances": [
        {
          "attributes": {
            "bucket": "om-tf-state-bucket",
            "id": "om-tf-state-bucket"
          }
        }
      ]
    }
  ]
}
```

#### **Why State Matters:**
- **Resource Tracking**: Terraform knows what exists vs. what should exist
- **Update Operations**: Terraform can modify existing resources instead of recreating
- **Dependency Management**: Terraform understands resource relationships
- **Destroy Operations**: Terraform knows what to delete

#### **State File Location Comparison:**

| Location | Path | Access | Team Sharing |
|----------|------|--------|--------------|
| **Local (Default)** | `./terraform.tfstate` | Your machine only | ❌ Manual sharing required |
| **Remote (This Setup)** | `s3://om-tf-state-bucket/terraform.tfstate` | Anyone with AWS access | ✅ Automatic |

---

### 💡 Benefits of Remote Backend

#### **Comparison Table:**

| Feature | Local Backend | Remote Backend (This Setup) |
|---------|--------------|----------------------------|
| **State Storage** | Local file (`terraform.tfstate`) | S3 bucket (cloud storage) |
| **State Locking** | ❌ Not available | ✅ DynamoDB table |
| **Team Collaboration** | ❌ Manual file sharing | ✅ Automatic & seamless |
| **State Backup** | ❌ Manual backup required | ✅ Automatic (S3 versioning available) |
| **Security** | ⚠️ Risk if file is deleted/stolen | ✅ Secure cloud storage |
| **Scalability** | ⚠️ Limited to one machine | ✅ Works from anywhere |
| **Concurrent Operations** | ❌ Can cause conflicts | ✅ Automatically prevented |
| **Recovery** | ❌ Difficult if file lost | ✅ Always recoverable from S3 |

#### **Real-World Scenarios:**

**Scenario 1: Team Collaboration**
```
❌ Without Remote Backend:
- Developer A creates infrastructure → state on their laptop
- Developer B tries to modify → needs state file → asks Developer A
- Developer A shares file → both have copies → conflict!

✅ With Remote Backend:
- Developer A creates infrastructure → state in S3
- Developer B modifies infrastructure → reads from S3 → locked → waits → proceeds
```

**Scenario 2: Machine Failure**
```
❌ Without Remote Backend:
- Laptop crashes → state file lost → cannot manage infrastructure
- Must recreate everything or lose control

✅ With Remote Backend:
- Laptop crashes → state safe in S3 → use any machine → continue working
```

**Scenario 3: Multiple Environments**
```
✅ With Remote Backend:
- Development state: s3://dev-state-bucket/dev.tfstate
- Production state: s3://prod-state-bucket/prod.tfstate
- Easy environment separation
```

---

### 🛡️ Security Best Practices

#### **Current Configuration:**
- ✅ State stored in S3 (cloud, not local machine)
- ✅ State locking prevents concurrent modifications
- ✅ DynamoDB prevents race conditions

#### **Recommended Enhancements:**

1. **Enable S3 Bucket Versioning:**
   ```hcl
   resource "aws_s3_bucket_versioning" "remote_s3_versioning" {
     bucket = aws_s3_bucket.remote_s3.id
     versioning_configuration {
       status = "Enabled"
     }
   }
   ```
   **Benefit**: Can restore previous state versions if something goes wrong

2. **Enable S3 Bucket Encryption:**
   ```hcl
   resource "aws_s3_bucket_server_side_encryption_configuration" "remote_s3_encryption" {
     bucket = aws_s3_bucket.remote_s3.id
     rule {
       apply_server_side_encryption_by_default {
         sse_algorithm = "AES256"
       }
     }
   }
   ```
   **Benefit**: State file encrypted at rest (state may contain sensitive data)

3. **Restrict S3 Bucket Access with IAM:**
   - Create IAM policy that allows only specific users/roles to access the bucket
   - Prevents unauthorized state file access

4. **Enable DynamoDB Point-in-Time Recovery:**
   ```hcl
   resource "aws_dynamodb_table" "basic-dynamodb-table" {
     # ... existing configuration ...
     point_in_time_recovery {
       enabled = true
     }
   }
   ```
   **Benefit**: Can recover from accidental data deletion

---

### 🔧 Troubleshooting Common Issues

#### **Issue 1: "Error: Failed to get existing workspaces"**
**Cause**: S3 bucket doesn't exist yet  
**Solution**: Create the bucket first, or use a different bucket name

#### **Issue 2: "Error acquiring the state lock"**
**Cause**: Another operation is running, or previous operation crashed  
**Solution**: 
- Wait for the other operation to complete
- If stuck, manually delete the lock from DynamoDB table

#### **Issue 3: "Bucket name already exists"**
**Cause**: S3 bucket names must be globally unique  
**Solution**: Change bucket name in `s3.tf` and `terraform.tf` to something unique

#### **Issue 4: "Access Denied" when accessing S3**
**Cause**: IAM user doesn't have permissions  
**Solution**: Ensure IAM user has:
- `s3:GetObject` on the bucket
- `s3:PutObject` on the bucket
- `dynamodb:GetItem` on the table
- `dynamodb:PutItem` on the table
- `dynamodb:DeleteItem` on the table

#### **Issue 5: "State file not found"**
**Cause**: Backend configured but state file doesn't exist in S3  
**Solution**: This is normal for first-time setup. Run `terraform apply` to create resources and state file.

---

### 📚 Additional Resources

- [Terraform S3 Backend Documentation](https://www.terraform.io/docs/language/settings/backends/s3.html)
- [Terraform State Lock Documentation](https://www.terraform.io/docs/language/state/locking.html)
- [AWS S3 Best Practices](https://docs.aws.amazon.com/AmazonS3/latest/userguide/security-best-practices.html)
- [DynamoDB On-Demand Billing](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/HowItWorks.ReadWriteCapacityMode.html#HowItWorks.OnDemand)
- [Terraform State Management](https://www.terraform.io/docs/language/state/index.html)

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
