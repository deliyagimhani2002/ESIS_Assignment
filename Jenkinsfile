// ==========================================================
// Lanka Mart CI/CD Pipeline - Jenkinsfile
// Description: Automates Docker build, push, and deployment 
// using Jenkins, Docker, and Ansible for Azure-hosted VM.
// Includes enhanced container monitoring and log retrieval.
// ==========================================================

pipeline {
    agent any    

    environment {
        // ================= Global Environment Variables =================
        IMAGE_NAME       = "lanka-mart-app"          // Docker image name
        IMAGE_TAG        = "latest"                  // Docker image tag 
        DOCKER_USER      = "deliya123"              // Docker Hub username
        CONTAINER_NAME   = "lanka-mart-app"         // Name of running container
        PORT             = "8081"                    // Port to access the container on VM
        PEM_KEY_PATH     = "/var/lib/jenkins/.ssh/ESIS_key.pem" // SSH private key path for Ansible
        ANSIBLE_HOSTS    = "hosts"                   // Ansible inventory file
        VM_IP            = "57.159.25.36"           // Public IP of the Azure VM
    }

    stages {

        // ================= Docker Access Check =================
        stage('Check Docker Access') {
            steps {
                sh '''
                    echo "=== Checking Docker Access ==="
                    which docker || echo "Docker not found"         # Verify docker CLI exists
                    docker --version || echo "Docker not available" # Verify Docker installation
                    docker ps || echo "Cannot access Docker daemon" # Verify Docker daemon is running
                    echo "==============================="
                '''
            }
        }

        // ================= Clone Repository =================
        stage('Clone Repository') {
            steps {
                // Fetch the latest application code from GitHub repository
                git branch: 'main', url: 'https://github.com/deliyagimhani2002/Lanka_Mart.git'
            }
        }

        // =================  Build Docker Image =================
        stage('Build Docker Image') {
            steps {
                sh """
                    echo "Building fresh Docker image..."
                    docker build --no-cache -t ${IMAGE_NAME}:${IMAGE_TAG} .   # Build image without cache
                """
            }
        }

        // ================= Push Docker Image =================
        stage('Push Docker Image to Docker Hub') {
            steps {
                withCredentials([string(credentialsId: 'deliya123', variable: 'DOCKER_PASS')]) {
                    sh """
                        echo "Logging into Docker Hub..."
                        echo \$DOCKER_PASS | docker login -u ${DOCKER_USER} --password-stdin
                        docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG}  # Tag image for Docker Hub
                        docker push ${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG}                                # Push image
                        echo "Image pushed successfully!"
                    """
                }
            }
        }

        // ================= Deploy via Ansible =================
        stage('Deploy via Ansible') {
            steps {
                withEnv(["ANSIBLE_PRIVATE_KEY_FILE=${PEM_KEY_PATH}", "ANSIBLE_HOST_KEY_CHECKING=False"]) {
                    sh """
                        echo "Deploying container on Azure VM using Ansible..."
                        ansible-playbook -i ${ANSIBLE_HOSTS} deploy.yml  # Run deployment playbook
                    """
                }
            }
        }

        // =================  Verify Deployment =================
        stage('Verify Deployment') {
            steps {
                script {
                    // Verify the deployed website is accessible and returns HTTP 200
                    def status = sh(
                        script: "curl -s -o /dev/null -w '%{http_code}' http://${VM_IP}:${PORT}",
                        returnStdout: true
                    ).trim()

                    if (status != "200") {
                        error("Website verification failed! HTTP status: ${status}")  // Fail pipeline if site is down
                    } else {
                        echo "Website is live! HTTP status: ${status}"  // Success message
                    }
                }
            }
        }

        // ================= Monitoring & Logging =================

        stage('Container Logging & Monitoring') {
    steps {
        script {
            echo "=== Checking container status and fetching logs on remote VM ==="
            sh """
                # SSH to Azure VM using correct private key and disable host key checks
                ssh -i ${PEM_KEY_PATH} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null azureuser@${VM_IP} '
                    # Check if the container is running
                    if docker ps --format "{{.Names}}" | grep -qw "${CONTAINER_NAME}"; then
                        echo "Container '${CONTAINER_NAME}' is running "
                        
                        # Fetch last 20 log lines if available
                        if [ \$(docker logs --tail 1 ${CONTAINER_NAME} 2>/dev/null | wc -l) -gt 0 ]; then
                            echo "=== Last 20 log lines ==="
                            docker logs --tail 20 ${CONTAINER_NAME}
                        else
                            echo "No logs available yet for '${CONTAINER_NAME}'"
                        fi
                    else
                        echo "Container '${CONTAINER_NAME}' is NOT running "
                    fi
                '
            """
        }
    }
}


        // ================= Health Check =================
        stage('Health Check') {
            steps {
                sh """
                    # Verify HTTP response code of deployed website
                    HTTP_STATUS=\$(curl -s -o /dev/null -w '%{http_code}' http://${VM_IP}:${PORT})
                    if [ "\$HTTP_STATUS" -eq 200 ]; then
                        echo "Website is up and running"
                    else
                        echo "Website is down, HTTP Status: \$HTTP_STATUS"
                    fi
                """
            }
        }

        // =================  Clean Up =================
        stage('Clean Up') {
            steps {
                // Remove unused Docker images to free disk space
                sh 'docker image prune -f'
            }
        }
    }

    // ================= Post Actions =================
    post {
        success {
            echo "CI/CD pipeline completed successfully!"  // Pipeline success message
        }
        failure {
            echo "Build failed — check logs for errors."   // Pipeline failure message
        }
    }
}



