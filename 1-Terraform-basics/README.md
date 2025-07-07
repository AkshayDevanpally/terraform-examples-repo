# 🚀 Terraform AWS EC2 Provisioning - Day 1

![Terraform use](./Brainboard%20-%20understanding%20terraform%20basics%20by%20creating%20instance%20on%20ec2%20via%20terraform.png)
![AWS EC2 Setup](./day1.drawio%20%281%29.png)

## 📘 About This Project

This repository showcases  setup of a Terraform-based infrastructure.

In this, we demonstrate how to connect Terraform with AWS and provision **two EC2 instances** using a clean and modular approach. This forms a strong foundation for infrastructure automation in any **DevOps** or **Cloud Engineering** journey.

---

## 🌍 What is Terraform?

**Terraform** is an open-source tool by HashiCorp used to automate the provisioning of cloud infrastructure. It uses **Infrastructure as Code (IaC)** principles, allowing you to define your entire cloud infrastructure using human-readable configuration files.

---

## 🔧 Why Use Terraform?

- **Consistency** in cloud resource creation
- **Version control** for infrastructure
- Easily **scale and modify** infrastructure
- **Multi-cloud support** (AWS, Azure, GCP, etc.)
- Ideal for **CI/CD and automation pipelines**

---

## 🛠️ Today's Focus: Terraform with AWS EC2

This project involves:

- Setting up the **AWS provider**
- Using variables for **flexibility and reusability**
- Creating **multiple EC2 instances**
- Applying modular and scalable configuration

---

## 🗂️ Project Structure
├── createinstance-16.tf # EC2 instance creation logic
├── main.tf # AWS provider configuration
├── myvar.tf # Variable definitions
├── images/ # Folder to store linked screenshots (logo, architecture)


---

## 📄 Breakdown of Terraform Files

### ✅ `main.tf`

Sets up the **AWS provider**, targeting the `us-east-1` region with version control.


provider "aws" {
  region  = "us-east-1"
  version = "~> 5.45.0"
}


Creates two EC2 instances using the count meta-argument and AMI ID.
resource "aws_instance" "MyFirstInstnace" {
  count         = 2
  ami           = "ami-0e9bbd70d26d7cf4f"
  instance_type = "t2.micro"
  tags = {
    Name = "demoinstnce-${count.index}"
  }
}

Defines a variable for demonstration purposes:
variable "myfirstvar" {
  type    = string
  default = "Hello! Welcome Terraform"
}

Variables enhance reusability and flexibility.

🧩 3 Common Ways to Use Variables:
Default values (as seen in myvar.tf)

Command-line override
terraform apply -var="myfirstvar=CustomMessage"

Variable files (*.tfvars)
terraform apply -var-file="custom.tfvars"

Here’s how to run this setup:

# Initialize the working directory
terraform init

# Review changes to be made
terraform plan

# Apply the configuration and create resources
terraform apply

📌 Don’t forget to export your AWS credentials before starting:

export AWS_ACCESS_KEY_ID=your_key
export AWS_SECRET_ACCESS_KEY=your_secret




