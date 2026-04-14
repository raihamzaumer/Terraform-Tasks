
---

# 🚀 Private EC2 Access via Squid Proxy (AWS + Terraform)

## 📌 Overview

This project demonstrates secure access to a private EC2-hosted Nginx server using a Squid Proxy running on a public EC2 instance. It ensures network isolation by keeping the backend server private while allowing controlled access through a proxy gateway.

## 🧠 Key Concepts

* AWS VPC (public & private subnets)
* EC2 Instances
* Squid Proxy Server
* Nginx Web Server
* Security Groups & Routing
* Terraform (Infrastructure as Code)

## 🔄 Architecture Flow

User → Squid Proxy (Public EC2) → Private EC2 (Nginx) → Response back to user

## ⚙️ Components

* **Private EC2:** Runs Nginx (no public IP)
* **Public EC2:** Runs Squid Proxy (port 8080)
* **VPC:** Separates public and private resources
* **Security Groups:** Restrict access between proxy and private server

## 🎯 Goal

To demonstrate secure, production-like architecture using proxy-based access to private AWS resources while maintaining isolation and security.
