# AWS IAM Roles, S3 Bucket, and EC2 Instance with Terraform

## 📘 Overview

This project showcases how to use **Terraform** to automate the provisioning of:

- An **S3 Bucket**  
- An **IAM Role** with associated **policies**  
- An **EC2 Instance**  
- IAM Role attachment to EC2, allowing it to upload files directly to the S3 bucket

---

## 🧱 Description

This setup demonstrates how an EC2 instance can securely interact with an S3 bucket using IAM roles and policies instead of hardcoded credentials. Key highlights:

- Creation of a custom **IAM Role** and inline policy for S3 access  
- Provisioning of an **EC2 instance** and attaching the IAM role  
- Secure file upload from EC2 to S3 using the assigned permissions

---

## 📊 Architecture Diagram

Below is a high-level architecture diagram showing the interaction between IAM, EC2, and S3:

![Terraform IAM Roles and S3 Architecture](Brainboard%20-%20aws%20iam%20roles%20and%20s3%20bucket.png)

---

## 🎬 Demo Video

You can watch the project in action in the following video:

🔗 [Watch Demo Video via GitHub Issue](https://github.com/user-attachments/assets/7d9e2980-783a-48a4-a909-52408b11a0ab)

If you uploaded the video directly to the repo, you can embed it like this:

[Click to watch](./aws-iamroles.mp4)

Or preview it via thumbnail:

[![Watch Video](Brainboard%20-%20aws%20iam%20roles%20and%20s3%20bucket.png)](./aws-iamroles.mp4)

---

## 🧩 Terraform Components

- **IAM Role**: Created with necessary policies to allow EC2 to write to S3  
- **S3 Bucket**: Provisioned with appropriate permissions  
- **EC2 Instance**: Launched and associated with the IAM Role  
- **User Data (optional)**: Can be added to install AWS CLI and test uploads to S3

