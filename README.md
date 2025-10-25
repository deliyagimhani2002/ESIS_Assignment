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

## Prerequisites
- Jenkins server with Docker plugin installed
- Docker installed on Jenkins and Azure VM
- Ansible installed on Jenkins control machine
- GitHub repository access
- Azure VM with SSH access and a user in the Docker group
- Docker Hub account for storing images

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

---

##  Accessing the App
Once deployed successfully, open the browser and visit:
http://57.159.25.36:8081
We can see the LankaMart homepage running on the Azure VM.

---

## Monitoring & Logging

To ensure that the LankaMart application operates reliably after deployment, **monitoring and logging mechanisms** are integrated into the CI/CD pipeline and deployment process. These mechanisms verify container health, track application behavior, and maintain operational transparency in line with **ISO-compliant practices**.

### Container Health Checks
After deployment, the Docker container running LankaMart is regularly monitored to confirm it is active and serving requests. Any failures or downtime are quickly detected, allowing prompt corrective action.

### Application Health Verification
The web application’s availability and responsiveness are continuously verified. This provides immediate feedback on deployment success and ensures users can reliably access the service.

### Log Monitoring
Runtime logs from the containerized application are captured and saved to a designated location on the server. This allows developers and administrators to review activity, identify potential issues, and maintain a historical record of container operations.  

### Integration with CI/CD Pipeline
Monitoring and logging are seamlessly integrated with Jenkins and Ansible:

- **Jenkins** checks the health of the deployed application and reports container status immediately after each deployment.  
- **Ansible** automates the collection and storage of container logs on the server for persistent tracking and auditing.

### Benefits

- Ensures the deployed application is operational and accessible  
- Provides historical logs for troubleshooting and auditing purposes  
- Supports ISO-compliant operational transparency and reliability  
- Enables quick detection of failures or performance issues, reducing downtime  

---
## Key Benefits

- Fully automated build → push → deploy process  
- Reduced manual effort and deployment errors  
- Scalable cloud-based infrastructure  
- ISO-aligned DevOps workflow (security, traceability, automation)
