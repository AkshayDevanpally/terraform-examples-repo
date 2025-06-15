# AWS RDS Deployment using Terraform

## 📘 Overview

This project demonstrates how to use **Terraform** to provision a fully functional **Amazon RDS instance** within a custom **Virtual Private Cloud (VPC)**. It includes:

- VPC creation with public and private subnets  
- Custom **Security Groups** for EC2 and RDS  
- Deployment of a **MariaDB RDS** instance  
- Optional: Launch an EC2 instance that connects to the RDS database  
- Separate and modular Terraform files for **networking**, **security**, and **database**

---

## 🌐 Infrastructure Architecture

Below is a high-level architecture diagram representing how the RDS setup is structured:

![Terraform AWS RDS Architecture](Brainboard%20-%20aws%20rds%20using%20terrafrom.png)

---

## 🎬 RDS Deployment Demo Video

### ▶️ Watch the demo directly below

<video width="100%" controls>
  <source src="https://github.com/user-attachments/assets/df958df9-65a1-49a4-947f-3aca5c6628c0" type="video/mp4">
  Your browser does not support the video tag.
</video>

---

## 🌐 Infrastructure Components

### 🔧 1. VPC and Subnets
- One VPC with multiple subnets (public and private)  
- Route tables and NAT Gateway configuration

### 🔐 2. Security Groups
- **EC2 Security Group** allowing SSH (port 22)  
- **RDS Security Group** allowing MySQL/MariaDB (port 3306) access from EC2

### 🛢️ 3. Amazon RDS
- MariaDB engine (`10.11`)  
- Custom parameter group and subnet group  
- Credentials (username/password) defined in Terraform *(use secrets in production)*  

---

## 🚀 Usage

```bash
terraform init
terraform plan
terraform apply
