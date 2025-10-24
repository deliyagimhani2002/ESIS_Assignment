pipeline {
  agent any

  stages {

    // Clone GitHub repository
    stage('Clone repository') {
      steps {
        git 'https://github.com/deliyagimhani2002/Lanka_Mart.git'
      }
    }

    //  Build Docker image
    stage('Build Docker image') {
      steps {
        sh 'docker build -t lanka-mart-app:1.0 .'
      }
    }

    //  Run container test and check if running
    stage('Run container test') {
      steps {
        sh '''
          set -e  # Exit immediately if a command fails

          docker run -d -p 8081:80 --name lanka-mart lanka-mart-app:1.0
          echo "Waiting for container to start..."
          until docker ps | grep lanka-mart; do
            sleep 1
          done
          echo "Container is up and running"

          # Health check using curl
          echo "Checking web app response..."
          for i in {1..10}; do
            if curl -s http://localhost:8081 | grep -q "<!DOCTYPE html>"; then
              echo "Web app is responding successfully!"
              break
            fi
            echo "Waiting for app to respond... ($i/10)"
            sleep 1
            if [ $i -eq 10 ]; then
              echo "ERROR: Web app did not respond in time!"
              exit 1  # Fail the pipeline
            fi
          done
        '''
      }
    }

    //  Push image to Docker Hub
    stage('Push to Docker Hub') {
      steps {
        withCredentials([string(credentialsId: 'deliya123', variable: 'DOCKER_PASS')]) {
          sh '''
            echo $DOCKER_PASS | docker login -u deliya123 --password-stdin
            docker tag lanka-mart-app:1.0 deliya123/lanka-mart-app:1.0
            docker push deliya123/lanka-mart-app:1.0
          '''
        }
      }
    }

    //  Cleanup: stop and remove container
    stage('Clean up container') {
      steps {
        sh '''
          docker stop lanka-mart || true
          docker rm -f lanka-mart || true
        '''
      }
    }

    //  Cleanup dangling Docker images
    stage('Clean up dangling images') {
      steps {
        sh '''
          echo "Removing dangling Docker images..."
          docker image prune -f
        '''
      }
    }

  }
}

 
