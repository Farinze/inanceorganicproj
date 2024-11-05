pipeline {
    agent any 

    environment {
        GIT_REPO_URL = "https://github.com/Farinze/inanceorganicproj.git"
        BRANCH_NAME = 'main'  // Target branch
        DOCKER_IMAGE_NAME = 'inanceorganicproj'  // Docker image name
        AWS_INSTANCE_IP = '107.22.123.119'
        SSH_KEY_CREDENTIAL_ID = '/var/lib/jenkins/inance.pem'  // Jenkins credentials ID for SSH key
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
                    docker.build("${DOCKER_IMAGE_NAME}:latest")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                // Optional: Tag and push the Docker image to a registry if using a remote registry
                // For example, if using Docker Hub or AWS ECR:
                // script {
                //     docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                //         docker.image("${DOCKER_IMAGE_NAME}:latest").push()
                //     }
                // }
            }
        }

        stage('Deploy to AWS') {
            steps {
                // SSH into the AWS instance to deploy Docker container
                sshagent (credentials: [SSH_KEY_CREDENTIAL_ID]) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ubuntu@${AWS_INSTANCE_IP} << EOF
                        # Pull the latest Docker image on the AWS instance
                        docker pull ${DOCKER_IMAGE_NAME}:latest

                        # Stop and remove any running container using the same image
                        docker ps -q --filter "ancestor=${DOCKER_IMAGE_NAME}" | xargs -r docker stop
                        docker ps -q --filter "ancestor=${DOCKER_IMAGE_NAME}" | xargs -r docker rm

                        # Run the container on port 80 mapped to the Django port 8000
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
