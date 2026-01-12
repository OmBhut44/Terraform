# 🚀 Terraform AWS Infrastructure Automation

A complete beginner-to-professional Terraform project that demonstrates how to provision AWS infrastructure using Infrastructure as Code (IaC) with security best practices.

This repository is designed to help developers, students, and DevOps engineers understand how to build, deploy, and manage AWS resources using Terraform in a clean and scalable way.

---

## 📌 Project Overview

This project uses Terraform to automate AWS infrastructure provisioning.

It demonstrates how to:

✅ Configure AWS provider  
✅ Manage AWS resources using Terraform  
✅ Follow DevOps & cloud security best practices  
✅ Implement Infrastructure as Code  
✅ Build repeatable cloud deployments  

This repository is beginner-friendly and suitable for real-world learning.

---

## 🧩 Technologies Used

- Terraform
- AWS (EC2, IAM, Security Groups)
- AWS CLI
- Git & GitHub

---

## 📦 Prerequisites

Before getting started, make sure you have:

- An AWS account
- Terraform installed
- AWS CLI installed
- Git installed
- IAM user with programmatic access

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
