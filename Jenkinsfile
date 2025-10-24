pipeline {
  agent any

  environment {
    IMAGE_NAME = "lanka-mart-app"
    IMAGE_TAG = "1.0"
    DOCKER_USER = "deliya123"
  }

  stages {

    // 1️⃣ Check Docker Access
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

    // 2️⃣ Clone the repository (explicitly use 'main' branch)
    stage('Clone repository') {
      steps {
        git branch: 'main', url: 'https://github.com/deliyagimhani2002/Lanka_Mart.git'
      }
    }

    // 3️⃣ Build Docker image
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

    // 4️⃣ Run container test
    stage('Run container test') {
      steps {
        sh '''
          set -x
          echo "Running container from built image..."
          docker run -d -p 8081:80 --name ${IMAGE_NAME} ${IMAGE_NAME}:${IMAGE_TAG}
          sleep 5
          echo "Checking if container is running..."
          docker ps | grep ${IMAGE_NAME} || (echo "Container not running!" && exit 1)
          echo "Container is up successfully!"
        '''
      }
    }

    // 5️⃣ Push to Docker Hub
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

    // 6️⃣ Clean up containers
    stage('Clean up containers') {
      steps {
        sh '''
          echo "Stopping and removing container..."
          docker stop ${IMAGE_NAME} || true
          docker rm -f ${IMAGE_NAME} || true
        '''
      }
    }

    // 7️⃣ Clean up dangling images
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
      echo "✅ Build pipeline completed successfully!"
    }
  }
}


 
