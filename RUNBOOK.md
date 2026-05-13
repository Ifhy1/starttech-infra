# Runbook

## Overview

This runbook covers common operations and troubleshooting steps for the StartTech application.

## Accessing the Application

- Frontend: http://muchtodo-frontend-dev.s3-website-us-east-1.amazonaws.com
- Backend API: http://muchtodo-alb-final-425877782.us-east-1.elb.amazonaws.com

## SSH into EC2

```bash
ssh -i ~/starttech-key.pem ubuntu@3.237.99.24
```

## Common Operations

### Check if backend is running
```bash
docker ps
```

### Check backend logs
```bash
docker logs backend
```

### Restart backend manually
```bash
docker stop backend
docker rm backend
docker run -d \
  --name backend \
  -p 8080:8080 \
  -e MONGO_URI="your-mongo-uri" \
  -e REDIS_ADDR="your-redis-addr" \
  -e JWT_SECRET_KEY="your-jwt-secret" \
  707733857169.dkr.ecr.us-east-1.amazonaws.com/starttech-backend:latest
```

### Deploy frontend manually
```bash
cd frontend
npm install
npm run build
aws s3 sync dist/ s3://muchtodo-frontend-dev --delete
```

## Troubleshooting

### 502 Bad Gateway on ALB
- SSH into EC2 and check if container is running with `docker ps`
- Check container logs with `docker logs backend`
- Restart the container manually

### Frontend not updating
- Check GitHub Actions frontend pipeline ran successfully
- Manually sync to S3 and invalidate CloudFront cache:
```bash
aws cloudfront create-invalidation --distribution-id E28UJ83TH7FXYA --paths "/*"
```

### MongoDB connection error
- Check MONGO_URI environment variable is set correctly
- Verify MongoDB Atlas cluster is running
- Check network access settings in MongoDB Atlas allow EC2 IP

### Redis connection error
- Verify ElastiCache cluster is running in AWS console
- Check security groups allow EC2 to connect to Redis on port 6379

## CI/CD Pipeline

### Trigger frontend deployment
Push any change to the frontend/ folder on main branch.

### Trigger backend deployment
Push any change to the backend/ folder on main branch.

### Manual trigger
Go to GitHub Actions and click Run workflow on either pipeline.
