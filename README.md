#  LankaMart DevOps CI/CD Pipeline

This repository contains a fully automated **CI/CD pipeline** for deploying the **LankaMart Web Application** using **Jenkins**, **Docker**, and **Ansible** on an **Azure Virtual Machine**.

The pipeline demonstrates how DevOps principles can automate building, testing, and deployment processes while maintaining ISO-aligned security and reliability standards.

---

##  Features

- Continuous Integration with **Jenkins**
- Containerization using **Docker**
- Automated deployment via **Ansible**
- Cloud deployment on **Azure VM**
- Version control with **GitHub**
- End-to-end verification and cleanup steps

---

##  Pipeline Workflow

1. **Checkout Code** – Clone the latest source from GitHub.  
2. **Build Docker Image** – Build a fresh Nginx-based image for the app.  
3. **Push Image to Docker Hub** – Upload image to Docker Hub repository.  
4. **Deploy with Ansible** – Pull and deploy latest image to Azure VM.  
5. **Verify Deployment** – Check if the application is live (`HTTP 200`).  
6. **Clean Up** – Remove unused Docker images to save space.

---

##  Project Structure
Lanka_Mart/
├── Dockerfile # Build instructions for Nginx web app
├── .dockerignore # Files to exclude from Docker build
├── Jenkinsfile # Jenkins pipeline for CI/CD
├── deploy.yml # Ansible playbook for deployment
├── hosts # Ansible inventory with Azure VM details
└── (Web Files) # index.html, css/, js/


