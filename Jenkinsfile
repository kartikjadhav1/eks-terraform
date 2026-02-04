pipeline {
    agent any
    environment {
        AWS_ACCOUNT_ID = "123456789012" // Your Account ID
        AWS_REGION     = "us-east-1"
        IMAGE_REPO     = "beyond-mumbai"
        IMAGE_TAG      = "${env.BUILD_NUMBER}" // Uses Jenkins build number as tag
        CLUSTER_NAME   = "dev-demo"
        AWS_CREDENTIAL = credentials('aws-credentials')
    }
    stages {
        stage('Login to ECR') {
            steps {
                sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
            }
        }
        stage('Build & Push Image') {
            steps {
                sh "docker build -t ${IMAGE_REPO}:${IMAGE_TAG} ."
                sh "docker tag ${IMAGE_REPO}:${IMAGE_TAG} ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${IMAGE_REPO}:${IMAGE_TAG}"
                sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${IMAGE_REPO}:${IMAGE_TAG}"
            }
        }
        stage('Deploy to EKS') {
            steps {
                // Update kubeconfig to point to your cluster
                sh "aws eks update-kubeconfig --name ${CLUSTER_NAME} --region ${AWS_REGION}"
                // Update the deployment with the new image
                sh "kubectl set image deployment/beyond-mumbai-app web-server=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${IMAGE_REPO}:${IMAGE_TAG}"
            }
        }
    }
}
