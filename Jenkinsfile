// ==========================================================
// Lanka Mart CI/CD Pipeline - Jenkinsfile
// Description: Automates Docker build, push, and deployment 
// using Jenkins, Docker, and Ansible for Azure-hosted VM.
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
                //  Validate that Docker is installed and accessible to Jenkins
                sh '''
                    echo "=== Checking Docker Access ==="
                    which docker || echo "Docker not found"
                    docker --version || echo "Docker not available"
                    docker ps || echo "Cannot access Docker daemon"
                    echo "==============================="
                '''
            }
        }

        stage('Clone Repository') {
            steps {
                //  Fetch latest application source code from GitHub repository
                git branch: 'main', url: 'https://github.com/deliyagimhani2002/Lanka_Mart.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                // Build a new Docker image without using cache
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
                //  Run Ansible playbook to pull latest Docker image and deploy it on Azure VM
                withEnv(["ANSIBLE_PRIVATE_KEY_FILE=${PEM_KEY_PATH}", "ANSIBLE_HOST_KEY_CHECKING=False"]) {
                    sh """
                        echo " Deploying container on Azure VM using Ansible..."
                        ansible-playbook -i ${ANSIBLE_HOSTS} deploy.yml
                    """
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                script {
                    //  Verify that the deployed web application is running successfully
                    def status = sh(
                        script: "curl -s -o /dev/null -w '%{http_code}' http://${VM_IP}:${PORT}",
                        returnStdout: true
                    ).trim()

                    if (status != "200") {
                        error(" Website verification failed! HTTP status: ${status}")
                    } else {
                        echo " Website is live! HTTP status: ${status}"
                    }
                }
            }
        }

        stage('Clean Up') {
            steps {
                //  Remove unused Docker images to free up disk space
                sh 'docker image prune -f'
            }
        }
    }

    post {
        //  Post-build notifications
        success {
            echo " CI/CD pipeline completed successfully!"
        }
        failure {
            echo " Build failed — check logs for errors."
        }
    }
}


