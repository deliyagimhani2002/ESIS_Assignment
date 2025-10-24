pipeline {
  agent any

  stages {

    // 1️⃣ Clone GitHub repository
    stage('Clone repository') {
      steps {
        git 'https://github.com/deliyagimhani2002/Lanka_Mart.git'
      }
    }

    // 2️⃣ Build Docker image
    stage('Build Docker image') {
      steps {
        sh 'docker build -t lanka-mart-app:1.0 .'
      }
    }

    // 3️⃣ Run container test and check if running
    stage('Run container test') {
      steps {
        sh '''
          docker run -d -p 8081:80 --name lanka-mart lanka-mart-app:1.0
          echo "Waiting for container to start..."
          until docker ps | grep lanka-mart; do
            sleep 1
          done
          echo "Container is up and running"
        '''
      }
    }

    // 4️⃣ Push image to Docker Hub
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

    // 5️⃣ Cleanup: stop and remove container
    stage('Clean up') {
      steps {
        sh '''
          docker stop lanka-mart || true
          docker rm -f lanka-mart || true
        '''
      }
    }

  }
}

