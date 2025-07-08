#  Software Provisioning with Terraform (File Upload + Remote Exec)

This project demonstrates **software provisioning** on AWS EC2 instances using **Terraform**. It provisions an EC2 instance and installs **Nginx** automatically using:

1. **File Provisioner** – Uploads a shell script to the EC2 instance
2. **Remote Exec Provisioner** – Executes that script remotely over SSH

> ⚡ We focus on practical infrastructure automation without using image builders like Packer.


🎥 **Terraform Building Blocks Demo Video**

[![Watch Video](https://img.shields.io/badge/Watch%20Video-Day%203-blue?logo=terraform)](https://github.com/user-attachments/assets/5c1ab065-afff-4583-9189-99b840b53b5b)


## 📖 What is Software Provisioning?

**Software provisioning** is the process of:
- Preparing infrastructure
- Installing required software and configurations
- Making resources ready for use in production or development environments

---

## 🛠️ Common Provisioning Approaches

| Method                        | Description                                              |
|-----------------------------|----------------------------------------------------------|
| 🔹 **Image-based (Packer)**  | Build a pre-baked VM/container image with all software  |
| 🔹 **Live provisioning**     | Upload and run scripts directly on instances (our focus) |

---

## ✅ Our Focus: Terraform with `file` + `remote-exec`

We’re provisioning a base EC2 instance and:
- Uploading `installNginx.sh` via `file` provisioner
- Executing it using `remote-exec`
- Key-based SSH access is used via the generated key pair

---

## 📁 File Structure

```bash
.
├── createinstance.tf       # Provisions EC2 and sets up provisioners
├── installNginx.sh         # Shell script to install and start nginx
├── provider.tf             # AWS provider config
├── variables.tf            # All input variables for reuse and flexibility
├── levelup_key             # Private key (generated via ssh-keygen)
├── levelup_key.pub         # Public key (used for AWS key pair)
```

⚙️ Terraform Breakdown
🖥️ createinstance.tf
Creates AWS key pair from levelup_key.pub

Launches EC2 using selected AMI and type
Uploads installNginx.sh to /tmp in the instance
Executes script via SSH using remote-exec

📜 installNginx.sh
Simple provisioning script that:

Waits until the instance is fully booted
Updates package manager
Installs and starts Nginx

🌐 provider.tf
Configures AWS provider using access keys and region

🔧 variables.tf
Defines all reusable variables like:

Access keys
Region
AMI IDs (map for multi-region)
Key file paths
SSH username

🔐 SSH Key Pair
Generate keys using:
```
ssh-keygen -f levelup_key
```
This creates:

levelup_key → private key (DO NOT share)
levelup_key.pub → public key (safe to upload to AWS)

How to Run This Project
1. Prerequisites
AWS credentials (Access Key, Secret Key)
Terraform installed (>=1.0)
SSH key pair generated (levelup_key, levelup_key.pub)
Security group allowing SSH (port 22) and HTTP (port 80) (optional)

2. 🔧 Edit variables.tf (if needed)
Update:
AWS_ACCESS_KEY
AWS_SECRET_KEY
Security_Group
INSTANCE_USERNAME (default is ubuntu)

3. 📤 Initialize & Apply Terraform
```
terraform init
terraform plan
terraform apply
```
4. 🖥️ Access the Instance
After provisioning:

Visit http://<EC2_PUBLIC_IP> → You should see the Nginx welcome page
Or SSH into the instance:
```
ssh -i levelup_key ubuntu@<EC2_PUBLIC_IP>
```
🧠 Highlights
No Packer needed to pre-build images
Uses standard provisioning approach with live instances
Teaches real-world Terraform techniques like:
file provisioner
remote-exec for custom install
SSH-based connection with key_pair

⚠️ Notes & Best Practices
Store access keys securely (use environment vars or secrets manager)
Never commit private keys to public repositories
Use user_data for cloud-init as a production-grade alternative
Consider switching to Ansible for large-scale provisioning
