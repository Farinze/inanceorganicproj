pipeline {
    agent any 

    environment {
        // Define environment variables
        GIT_REPO_URL = 'https://github.com/Farinze/inanceorganicproj.git'
        BRANCH_NAME = 'main'
        DOCKER_IMAGE_NAME = 'Farinze/inanceorganicproj:latest'  // Replace with your Docker Hub or ECR repository name
        AWS_INSTANCE_IP = '54.209.248.46'
        SSH_KEY_PATH = 'inanceorg'  // Jenkins credentials ID for SSH key
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the specified branch from GitHub
                git branch: BRANCH_NAME, url: GIT_REPO_URL
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                // Build and push Docker image to a registry
                withCredentials([usernamePassword(credentialsId: 'dockerhub_credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh """
                        # Login to Docker registry
                        echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

                        # Build the Docker image
                        docker build -t ${DOCKER_IMAGE_NAME} .

                        # Push the Docker image to Docker Hub (or your registry)
                        docker push ${DOCKER_IMAGE_NAME}
                    """
                }
            }
        }

        stage('Deploy to AWS') {
            steps {
                // SSH into the AWS instance and pull/run the Docker image
                sshagent (credentials: [SSH_KEY_PATH]) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ubuntu@${AWS_INSTANCE_IP} << EOF
                        docker pull ${DOCKER_IMAGE_NAME}
                        docker stop \$(docker ps -q --filter "ancestor=${DOCKER_IMAGE_NAME}")
                        docker rm \$(docker ps -q --filter "ancestor=${DOCKER_IMAGE_NAME}")
                        docker run -d -p 80:8000 ${DOCKER_IMAGE_NAME}
                    EOF
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment completed successfully.'
        }
        failure {
            echo 'Deployment failed.'
        }
    }
}
