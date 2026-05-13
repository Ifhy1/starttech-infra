#!/bin/bash

echo "Rolling back backend to previous version..."

ECR_REGISTRY="707733857169.dkr.ecr.us-east-1.amazonaws.com"
ECR_REPOSITORY="starttech-backend"

ssh -i ~/starttech-key.pem ubuntu@3.237.99.24 << 'EOF'
  docker stop backend || true
  docker rm backend || true
  docker run -d \
    --name backend \
    -p 8080:8080 \
    -e MONGO_URI=$MONGO_URI \
    -e REDIS_ADDR=$REDIS_ADDR \
    -e JWT_SECRET_KEY=$JWT_SECRET_KEY \
    707733857169.dkr.ecr.us-east-1.amazonaws.com/starttech-backend:previous
  echo "Rollback complete!"
EOF