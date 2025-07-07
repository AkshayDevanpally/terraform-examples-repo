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
{
 "cells": [
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "## 📄 Breakdown of Terraform Files"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "### ✅ `main.tf`\n",
    "\n",
    "Sets up the **AWS provider**, targeting the `us-east-1` region with version control."
   ]
  },
  {
   "cell_type": "code",
   "metadata": {},
   "execution_count": null,
   "outputs": [],
   "source": [
    "provider \"aws\" {\n",
    "  region  = \"us-east-1\"\n",
    "  version = \"~> 5.45.0\"\n",
    "}"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "Creates two EC2 instances using the `count` meta-argument and AMI ID."
   ]
  },
  {
   "cell_type": "code",
   "metadata": {},
   "execution_count": null,
   "outputs": [],
   "source": [
    "resource \"aws_instance\" \"MyFirstInstnace\" {\n",
    "  count         = 2\n",
    "  ami           = \"ami-0e9bbd70d26d7cf4f\"\n",
    "  instance_type = \"t2.micro\"\n",
    "  tags = {\n",
    "    Name = \"demoinstnce-${count.index}\"\n",
    "  }\n",
    "}"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "Defines a variable for demonstration purposes:"
   ]
  },
  {
   "cell_type": "code",
   "metadata": {},
   "execution_count": null,
   "outputs": [],
   "source": [
    "variable \"myfirstvar\" {\n",
    "  type    = string\n",
    "  default = \"Hello! Welcome Terraform\"\n",
    "}"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "Variables enhance reusability and flexibility.\n",
    "\n",
    "🧩 **3 Common Ways to Use Variables:**\n",
    "\n",
    "1. **Default values** (as seen in `myvar.tf`)\n",
    "2. **Command-line override**  \n",
    "`terraform apply -var=\"myfirstvar=CustomMessage\"`\n",
    "3. **Variable files** (`*.tfvars`)  \n",
    "`terraform apply -var-file=\"custom.tfvars\"`"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "### 🚀 How to Run This Setup:"
   ]
  },
  {
   "cell_type": "code",
   "metadata": {},
   "execution_count": null,
   "outputs": [],
   "source": [
    "# Initialize the working directory\n",
    "terraform init"
   ]
  },
  {
   "cell_type": "code",
   "metadata": {},
   "execution_count": null,
   "outputs": [],
   "source": [
    "# Review changes to be made\n",
    "terraform plan"
   ]
  },
  {
   "cell_type": "code",
   "metadata": {},
   "execution_count": null,
   "outputs": [],
   "source": [
    "# Apply the configuration and create resources\n",
    "terraform apply"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "📌 **Don’t forget to export your AWS credentials before starting:**"
   ]
  },
  {
   "cell_type": "code",
   "metadata": {},
   "execution_count": null,
   "outputs": [],
   "source": [
    "export AWS_ACCESS_KEY_ID=your_key\n",
    "export AWS_SECRET_ACCESS_KEY=your_secret"
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Terraform Guide",
   "language": "markdown",
   "name": "python3"
  },
  "language_info": {
   "name": "markdown"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}




