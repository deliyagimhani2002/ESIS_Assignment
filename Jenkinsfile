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

    // 1️⃣ Check Docker access
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

    // 2️⃣ Clone repository (main branch)
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

    // 4️⃣ Push image to Docker Hub
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

    // 5️⃣ Deploy new container (without deleting permanently)
    stage('Deploy Container') {
      steps {
        sh '''
          set -x
          echo "Checking if old container exists..."
          if [ "$(docker ps -aq -f name=${CONTAINER_NAME})" ]; then
            echo "Stopping old container..."
            docker stop ${CONTAINER_NAME} || true
            echo "Removing old container..."
            docker rm ${CONTAINER_NAME} || true
          fi

          echo "Running new container on port ${PORT}..."
          docker run -d -p ${PORT}:80 --name ${CONTAINER_NAME} ${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG}

          echo "Checking if container is running..."
          docker ps | grep ${CONTAINER_NAME} || (echo "Container failed to start!" && exit 1)

          echo "Deployment completed successfully!"
        '''
      }
    }

    // 6️⃣ Optional: Clean dangling images
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
      echo "Application deployed at: http://localhost:${PORT}"
    }
  }
}



 
