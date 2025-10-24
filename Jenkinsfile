pipeline {
  agent any

  environment {
    IMAGE_NAME = "lanka-mart-app"
    IMAGE_TAG = "1.0"
    DOCKER_USER = "deliya123"
    CONTAINER_NAME = "lanka-mart-app"
    PORT = "8081"
  }

  stages {

    // Check Docker access on Jenkins
    stage('Check Docker Access') {
      steps {
        sh '''
          echo "=== Checking Docker Access in Jenkins Environment ==="
          which docker || echo "Docker not found in PATH"
          docker --version || echo "Docker not available"
          docker ps || echo "Cannot access Docker daemon"
          echo "====================================================="
        '''
      }
    }

    //  Clone repository (main branch)
    stage('Clone repository') {
      steps {
        git branch: 'main', url: 'https://github.com/deliyagimhani2002/Lanka_Mart.git'
      }
    }

    //  Build Docker image
    stage('Build Docker image') {
      steps {
        sh '''
          set -x
          echo "Building Docker image..."
          docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
          echo "Image built successfully!"
        '''
      }
    }

    //  Push image to Docker Hub
    stage('Push to Docker Hub') {
      steps {
        withCredentials([string(credentialsId: 'deliya123', variable: 'DOCKER_PASS')]) {
          sh '''
            set -x
            echo "Logging in to Docker Hub..."
            echo $DOCKER_PASS | docker login -u ${DOCKER_USER} --password-stdin
            echo "Tagging and pushing image..."
            docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG}
            docker push ${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG}
            echo "Image pushed successfully!"
          '''
        }
      }
    }

    //  Deploy to Azure VM via Ansible
    stage('Deploy via Ansible') {
      steps {
        sshagent(['vm-ssh-credentials']) { // SSH key for Ansible to connect to VM
          sh '''
            echo "Running Ansible playbook to deploy application on Azure VM..."
            ansible-playbook -i hosts deploy.yml
          '''
        }
      }
    }

    //  Clean dangling Docker images
    stage('Clean up images') {
      steps {
        sh '''
          echo "Removing dangling images..."
          docker image prune -f
        '''
      }
    }
  }

  post {
    failure {
      echo "❌ Build failed — check logs for details."
    }
    success {
      echo "✅ CI/CD pipeline completed successfully!"
      echo "Application deployed on Azure VM via Ansible."
    }
  }
}


