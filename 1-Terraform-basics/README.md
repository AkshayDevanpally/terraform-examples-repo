# Terraform AWS EC2 Provisioning - Day 1

![Terraform use](./Brainboard%20-%20understanding%20terraform%20basics%20by%20creating%20instance%20on%20ec2%20via%20terraform.png)
![AWS EC2 Setup](./day1.drawio%20%281%29.png)

## About This Project

This repository showcases  setup of a Terraform-based infrastructure.

In this, we demonstrate how to connect Terraform with AWS and provision **two EC2 instances** using a clean and modular approach. This forms a strong foundation for infrastructure automation in any **DevOps** or **Cloud Engineering** journey.

---

##  What is Terraform?

**Terraform** is an open-source tool by HashiCorp used to automate the provisioning of cloud infrastructure. It uses **Infrastructure as Code (IaC)** principles, allowing you to define your entire cloud infrastructure using human-readable configuration files.

---

## 🔧 Why Use Terraform?

- **Consistency** in cloud resource creation
- **Version control** for infrastructure
- Easily **scale and modify** infrastructure
- **Multi-cloud support** (AWS, Azure, GCP, etc.)
- Ideal for **CI/CD and automation pipelines**

---

##  Today's Focus: Terraform with AWS EC2

This project involves:

- Setting up the **AWS provider**
- Using variables for **flexibility and reusability**
- Creating **multiple EC2 instances**
- Applying modular and scalable configuration

---

## 🗂Project Structure
├── createinstance-16.tf # EC2 instance creation logic
├── main.tf # AWS provider configuration
├── myvar.tf # Variable definitions


##  Breakdown of Terraform Files

### ✅ `main.tf`

Sets up the **AWS provider** with region and version control:

```hcl
provider "aws" {
  region  = "us-east-1"
  version = "~> 5.45.0"
}
```

🖥 EC2 Instance Provisioning
Creates 2 EC2 instances using the count meta-argument and tags them dynamically:

```
resource "aws_instance" "MyFirstInstnace" {
  count         = 2
  ami           = "ami-0e9bbd70d26d7cf4f"
  instance_type = "t2.micro"

  tags = {
    Name = "demoinstnce-${count.index}"
  }
}
```

Variables (Declared in myvar.tf)
Defines a simple string variable:

```
variable "myfirstvar" {
  type    = string
  default = "Hello! Welcome Terraform"
}
```
 Common Ways to Use Variables
 Default value (as shown above)

Override via CLI
```
terraform apply -var="myfirstvar=CustomMessage"
```
 Using a .tfvars file
```
terraform apply -var-file="custom.tfvars"
```

How to Run This Project
```
# Step 1: Initialize Terraform
terraform init

# Step 2: Preview the execution plan
terraform plan

# Step 3: Apply the configuration
terraform apply
```

AWS Credentials Setup
Before applying, make sure your AWS credentials are configured:
```
export AWS_ACCESS_KEY_ID=your_key
export AWS_SECRET_ACCESS_KEY=your_secret
```



