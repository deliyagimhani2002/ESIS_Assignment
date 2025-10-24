pipeline {
    agent any

    stages {

        // Clone GitHub repository
        stage('Clone repository') {
            steps {
                git 'https://github.com/deliyagimhani2002/Lanka_Mart.git'
            }
        }

        // Build Docker image
        stage('Build Docker image') {
            steps {
                bat 'docker build -t lanka-mart-app:1.0 .'
            }
        }

        // Run container test and check if running
        stage('Run container test') {
            steps {
                bat '''
                docker run -d -p 8081:80 --name lanka-mart lanka-mart-app:1.0
                timeout /t 10
                docker ps
                curl http://localhost:8081
                '''
            }
        }

        // Push image to Docker Hub
        stage('Push to Docker Hub') {
            steps {
                withCredentials([string(credentialsId: 'deliya123', variable: 'DOCKER_PASS')]) {
                    bat '''
                    echo %DOCKER_PASS% | docker login -u deliya123 --password-stdin
                    docker tag lanka-mart-app:1.0 deliya123/lanka-mart-app:1.0
                    docker push deliya123/lanka-mart-app:1.0
                    '''
                }
            }
        }

        // Cleanup: stop and remove container
        stage('Clean up container') {
            steps {
                bat '''
                docker stop lanka-mart || exit 0
                docker rm -f lanka-mart || exit 0
                '''
            }
        }

        // Cleanup dangling Docker images
        stage('Clean up dangling images') {
            steps {
                bat '''
                docker image prune -f
                '''
            }
        }
    }
}


 
