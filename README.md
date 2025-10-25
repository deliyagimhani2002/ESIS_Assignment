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

1. Dockerfile # Build instructions for Nginx web app
2. .dockerignore # Files to exclude from Docker build
3. Jenkinsfile # Jenkins pipeline for CI/CD
4. deploy.yml # Ansible playbook for deployment
5. hosts # Ansible inventory with Azure VM details
6. Web Files # index.html, css/, js/

##  Accessing the App
Once deployed successfully, open the browser and visit:
http://57.159.25.36:8081
We can see the LankaMart homepage running on the Azure VM.

##  Key Benefits
1. Fully automated build → push → deploy process
2. Reduced manual effort and deployment errors
3. Scalable cloud-based infrastructure
4. ISO-aligned DevOps workflow (security, traceability, automation)
