# AWS Auto Scaling and CloudWatch using Terraform

## 📘 Overview

This project demonstrates how to implement **Auto Scaling** in AWS using **Terraform**. It includes:

- A **Launch Template** for EC2 instances  
- Configuration of **Auto Scaling Groups (ASGs)**  
- Setup of **CloudWatch Alarms** for CPU-based scaling  
- Dynamic scale-up and scale-down based on CPU usage  
- Deployment in specific **VPC** and **availability zones**

---

## 🧱 Description

This setup provisions a scalable and self-adjusting infrastructure that maintains performance and cost efficiency:

- Automatically **scales up** instances when CPU utilization exceeds **30%**
- Automatically **scales down** when CPU utilization drops below **10%**
- Uses **CloudWatch Alarms** to monitor CPU metrics
- Deploys in **multiple availability zones** for high availability

---

## 📊 Architecture Diagram

Below is a high-level architecture diagram showing how Terraform provisions AWS Auto Scaling and integrates with CloudWatch:

![Terraform Auto Scaling Architecture](Brainboard-aws-autoscaling-and-cloud-watch-using-terraform.png)

---

## 🎬 Demo Video

You can watch the project in action in the following video:

🔗 [Watch Demo Video via GitHub Issue](https://github.com/user-attachments/assets/5bfb29d7-8924-4bee-b7d2-7901d8b2e26d)

[![Watch Terraform Auto Scaling Video](Brainboard-aws-autoscaling-and-cloud-watch-using-terraform.png)](https://github.com/user-attachments/assets/5bfb29d7-8924-4bee-b7d2-7901d8b2e26d)

---

## 🧩 Terraform Components

- **Launch Template**: Defines instance AMI, type, key pair, and user data  
- **Auto Scaling Group**: Defines min, max, and desired capacity, as well as subnets and health checks  
- **CloudWatch Alarms**: Configured to monitor average CPU usage  
  - Scale **out** when CPU > 30%  
  - Scale **in** when CPU < 10%  
- **Target Groups (optional)**: Can be attached to Load Balancers

---

## 🚀 Usage

```bash
terraform init
terraform plan
terraform apply

