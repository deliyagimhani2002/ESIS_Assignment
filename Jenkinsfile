pipeline {
    agent any

    environment {
        IMAGE_NAME       = "lanka-mart-app"
        IMAGE_TAG        = "1.0"
        DOCKER_USER      = "deliya123"
        CONTAINER_NAME   = "lanka-mart-app"
        PORT             = "8081"
        PEM_KEY_PATH     = "/var/lib/jenkins/.ssh/ESIS_key.pem"
        ANSIBLE_HOSTS    = "hosts"
        VM_IP            = "57.159.25.36"
    }

    stages {

        stage('Check Docker Access') {
            steps {
                sh '''
                    echo "=== Checking Docker Access ==="
                    which docker || echo "Docker not found"
                    docker --version || echo "Docker not available"
                    docker ps || echo "Cannot access Docker daemon"
                    echo "============================="
                '''
            }
        }

        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/deliyagimhani2002/Lanka_Mart.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                    echo "Building Docker image..."
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                    echo "Image built successfully!"
                """
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([string(credentialsId: 'deliya123', variable: 'DOCKER_PASS')]) {
                    sh """
                        echo "Logging in to Docker Hub..."
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
                withEnv(["ANSIBLE_PRIVATE_KEY_FILE=${PEM_KEY_PATH}", "ANSIBLE_HOST_KEY_CHECKING=False"]) {
                    sh """
                        echo "Running Ansible playbook..."
                        ansible-playbook -i ${ANSIBLE_HOSTS} deploy.yml
                        echo "Deployment completed!"
                    """
                }
            }
        }

        stage('Verify Website') {
            steps {
                script {
                    def status = sh(
                        script: "curl -s -o /dev/null -w '%{http_code}' http://${VM_IP}:${PORT}",
                        returnStdout: true
                    ).trim()

                    if (status != "200") {
                        error("Website verification failed! HTTP status: ${status}")
                    } else {
                        echo "Website verification successful! HTTP status: ${status}"
                    }
                }
            }
        }

        stage('Clean Up Images') {
            steps {
                sh 'docker image prune -f'
            }
        }
    }

    post {
        success {
            echo "CI/CD pipeline completed successfully!"
        }
        failure {
            echo "Build failed — check logs for details."
        }
    }
}



