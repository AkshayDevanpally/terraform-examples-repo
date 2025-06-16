# AWS Load Balancer Infrastructure using Terraform

## 📘 Overview

This project demonstrates how to provision an **AWS Elastic Load Balancer (ELB)** architecture using **Terraform**. It includes:

- VPC with public/private subnets  
- EC2 instances launched via **Launch Templates**  
- An **Elastic Load Balancer** (ELB)  
- Auto Scaling Group for dynamic instance management  
- Security Groups for secure access  
- CloudWatch metrics integration (optional)

---

## 🧱 Description

This setup provisions a scalable and highly available web architecture using:

- Custom **VPC** with multiple public/private subnets  
- A **Launch Template** for EC2 instance definitions  
- An **Auto Scaling Group** integrated with the ELB  
- Public **Route Tables** and **Internet Gateway** for connectivity  
- Proper **Security Groups** for both EC2 and ELB  
- Optional: Key pair for SSH access and monitoring setup

---

## 📊 Architecture Diagram

Below is a high-level architecture diagram that outlines the entire infrastructure:

![Terraform ELB Architecture](Brainboard%20-%20aws-elb-terraform.png)

---

## 🎬 Demo Video

You can watch the project in action in the following video:

🔗 [Watch Demo Video via GitHub Issue](https://github.com/user-attachments/assets/27d78c22-1dfb-4a34-bcec-1be14483cc94)

[![Watch Terraform ELB Video](Brainboard%20-%20aws-elb-terraform.png)](https://github.com/user-attachments/assets/27d78c22-1dfb-4a34-bcec-1be14483cc94)

---

## 🧩 Terraform Components

- **VPC & Subnets**: Includes both public and private subnets across multiple availability zones  
- **Internet Gateway & Route Tables**: Provides internet access to public subnet  
- **Launch Template**: Defines EC2 instance configuration  
- **Auto Scaling Group**: Automatically scales EC2 instances behind the ELB  
- **Elastic Load Balancer (ELB)**: Distributes incoming traffic across EC2 instances  
- **Security Groups**: Separate groups for ELB and EC2 for controlled access  
- **Key Pair**: For SSH access (used only during development or diagnostics)

---

## 🚀 Usage

```bash
terraform init
terraform plan
terraform apply

