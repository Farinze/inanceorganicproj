pipeline {
    agent any 

    environment {
        // Define environment variables
        GIT_REPO_URL = "https://github.com/Farinze/inanceorganicproj.git"  // URL in quotes
        BRANCH_NAME = 'main'  // Change to your target branch if needed
        DOCKER_IMAGE_NAME = 'inanceorganicproj'  // Docker image name for your app
        AWS_INSTANCE_IP = '107.22.123.119'
        SSH_KEY_PATH = '/var/lib/jenkins/inance.pem'  // Jenkins credentials ID for the SSH key
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the specified branch from GitHub
                git branch: BRANCH_NAME, url: GIT_REPO_URL
            }
        }

        stage('Build Docker Image') {
            steps {
                // Build Docker image for the Django app
                script {
                    docker.build("${DOCKER_IMAGE_NAME}")
                }
            }
        }

        stage('Deploy to AWS') {
            steps {
                // SSH into the AWS instance to deploy Docker container
                sshagent (credentials: [SSH_KEY_PATH]) {
                    sh """
                    ssh -o StrictHostKeyChecking=no -i ${SSH_KEY_PATH}.pem ubuntu@${AWS_INSTANCE_IP} << EOF
                        docker pull ${DOCKER_IMAGE_NAME}:latest
                        docker stop \$(docker ps -q --filter "ancestor=${DOCKER_IMAGE_NAME}")
                        docker rm \$(docker ps -q --filter "ancestor=${DOCKER_IMAGE_NAME}")
                        docker run -d -p 80:8000 ${DOCKER_IMAGE_NAME}:latest
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

