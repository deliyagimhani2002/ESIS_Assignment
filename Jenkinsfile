// ==========================================================
// Lanka Mart CI/CD Pipeline - Jenkinsfile
// Description: Automates Docker build, push, and deployment 
// using Jenkins, Docker, and Ansible for Azure-hosted VM.
// Includes enhanced container monitoring and log retrieval.
// ==========================================================

pipeline {
    agent any   

    environment {
        // Global Environment Variables
        IMAGE_NAME       = "lanka-mart-app"          // Docker image name
        IMAGE_TAG        = "latest"                  // Docker image tag (version)
        DOCKER_USER      = "deliya123"               // Docker Hub username
        CONTAINER_NAME   = "lanka-mart-app"          // Name of running container
        PORT             = "8081"                    // VM port to map container
        PEM_KEY_PATH     = "/var/lib/jenkins/.ssh/ESIS_key.pem" // SSH private key path for Ansible
        ANSIBLE_HOSTS    = "hosts"                   // Ansible inventory file
        VM_IP            = "57.159.25.36"            // Public IP of the Azure VM
    }

    stages {

        stage('Check Docker Access') {
            steps {
                // Verify Docker is installed and accessible to Jenkins
                sh '''
                    echo "=== Checking Docker Access ==="
                    which docker || echo "Docker not found"         # Check if docker CLI exists
                    docker --version || echo "Docker not available" # Check Docker version
                    docker ps || echo "Cannot access Docker daemon" # Verify Docker daemon can list containers
                    echo "==============================="
                '''
            }
        }

        stage('Clone Repository') {
            steps {
                // Fetch the latest application code from GitHub
                git branch: 'main', url: 'https://github.com/deliyagimhani2002/Lanka_Mart.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                // Build a fresh Docker image without using cache
                sh """
                    echo "Building fresh Docker image..."
                    docker build --no-cache -t ${IMAGE_NAME}:${IMAGE_TAG} .
                """
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                // Authenticate with Docker Hub and push the image
                withCredentials([string(credentialsId: 'deliya123', variable: 'DOCKER_PASS')]) {
                    sh """
                        echo "Logging into Docker Hub..."
                        echo \$DOCKER_PASS | docker login -u ${DOCKER_USER} --password-stdin
                        docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG}
                        docker push ${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG}
                        echo "Image pushed successfully!"
                    """
                }
            }
        }

        stage('Deploy via Ansible') {
            steps {
                // Run Ansible playbook to deploy the container on Azure VM
                withEnv(["ANSIBLE_PRIVATE_KEY_FILE=${PEM_KEY_PATH}", "ANSIBLE_HOST_KEY_CHECKING=False"]) {
                    sh """
                        echo "Deploying container on Azure VM using Ansible..."
                        ansible-playbook -i ${ANSIBLE_HOSTS} deploy.yml
                    """
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                script {
                    // Verify that the deployed website is running successfully
                    def status = sh(
                        script: "curl -s -o /dev/null -w '%{http_code}' http://${VM_IP}:${PORT}",
                        returnStdout: true
                    ).trim()

                    if (status != "200") {
                        error("Website verification failed! HTTP status: ${status}") // Fail pipeline if website is down
                    } else {
                        echo "Website is live! HTTP status: ${status}" // Success message if website is up
                    }
                }
            }
        }

        // ================= Monitoring & Logging Stages =================

        stage('Container Logging & Monitoring') {
            steps {
                // Check container status and fetch last log lines
                sh """
                    echo "=== Checking container status ==="
                    if docker ps | grep -q ${CONTAINER_NAME}; then
                        echo "Container '${CONTAINER_NAME}' is running"   # Container is active
                        
                        echo "=== Fetching last 20 log lines ==="
                        docker logs --tail 20 ${CONTAINER_NAME} || echo "No logs available" # Show recent logs
                    else
                        echo "Container '${CONTAINER_NAME}' is NOT running" # Container not found
                    fi
                """
            }
        }

        stage('Health Check') {
            steps {
                // Verify the HTTP status of the deployed website
                sh """
                    HTTP_STATUS=\$(curl -s -o /dev/null -w '%{http_code}' http://${VM_IP}:${PORT})
                    if [ "\$HTTP_STATUS" -eq 200 ]; then
                        echo "Website is up and running"
                    else
                        echo " Website is down, HTTP Status: \$HTTP_STATUS"
                    fi
                """
            }
        }

        // ===================================================================

        stage('Clean Up') {
            steps {
                // Remove unused Docker images to free up disk space
                sh 'docker image prune -f'
            }
        }
    }

    post {
        // Post-build notifications in Jenkins console
        success {
            echo "CI/CD pipeline completed successfully!" // Display success message
        }
        failure {
            echo "Build failed — check logs for errors." // Display failure message
        }
    }
}



