// ==========================================================
// Lanka Mart CI/CD Pipeline - Jenkinsfile
// Description: Automates Docker build, push, and deployment 
// using Jenkins, Docker, and Ansible for Azure-hosted VM.
// Includes basic container monitoring and log retrieval.
// ==========================================================

pipeline {
    agent any   // Use any available Jenkins agent to run the pipeline

    environment {
        // Global Environment Variables
        IMAGE_NAME       = "lanka-mart-app"          // Docker image name
        IMAGE_TAG        = "latest"                  // Image version tag
        DOCKER_USER      = "deliya123"               // Docker Hub username
        CONTAINER_NAME   = "lanka-mart-app"          // Container name during deployment
        PORT             = "8081"                    // Application port on VM
        PEM_KEY_PATH     = "/var/lib/jenkins/.ssh/ESIS_key.pem" // SSH key for Ansible
        ANSIBLE_HOSTS    = "hosts"                   // Ansible inventory file
        VM_IP            = "57.159.25.36"            // Public IP of the Azure VM
    }

    stages {

        stage('Check Docker Access') {
            steps {
                // Verify Docker is installed and accessible to Jenkins
                sh '''
                    echo "=== Checking Docker Access ==="
                    which docker || echo "Docker not found"         # Check Docker CLI
                    docker --version || echo "Docker not available" # Check Docker version
                    docker ps || echo "Cannot access Docker daemon" # Verify Docker daemon access
                    echo "==============================="
                '''
            }
        }

        stage('Clone Repository') {
            steps {
                // Fetch the latest source code from GitHub
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
                // Authenticate and push Docker image to Docker Hub
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
                // Use Ansible to deploy Docker container on Azure VM
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
                    // Verify the website is running by checking HTTP status
                    def status = sh(
                        script: "curl -s -o /dev/null -w '%{http_code}' http://${VM_IP}:${PORT}",
                        returnStdout: true
                    ).trim()

                    if (status != "200") {
                        error("Website verification failed! HTTP status: ${status}")
                    } else {
                        echo "Website is live! HTTP status: ${status}"
                    }
                }
            }
        }

        // ================= Monitoring & Logging Stages =================

        stage('Container Logging & Monitoring') {
            steps {
                //  monitoring: check container status and fetch last log lines
                sh """
                    echo "=== Checking container status ==="
                    docker ps | grep ${CONTAINER_NAME} || echo "Container not running"

                    echo "=== Fetching last 20 log lines ==="
                    docker logs --tail 20 ${CONTAINER_NAME} || echo "No logs available"
                """
            }
        }

        stage('Health Check') {
            steps {
                // HTTP health check of deployed website
                sh """
                    HTTP_STATUS=\$(curl -s -o /dev/null -w '%{http_code}' http://${VM_IP}:${PORT})
                    if [ "\$HTTP_STATUS" -eq 200 ]; then
                        echo " Website is up and running"
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
            echo "CI/CD pipeline completed successfully!"
        }
        failure {
            echo "Build failed — check logs for errors."
        }
    }
}



