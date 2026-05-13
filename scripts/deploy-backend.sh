#!/bin/bash

echo "Deploying backend to ECR and EC2..."

ECR_REGISTRY="707733857169.dkr.ecr.us-east-1.amazonaws.com"
ECR_REPOSITORY="starttech-backend"
IMAGE_TAG="latest"

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_REGISTRY

cd backend/MuchToDo
docker build -t $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG .
docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG

echo "Backend image pushed to ECR successfully!"