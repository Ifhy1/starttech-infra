#!/bin/bash

echo "Running health checks..."

BACKEND_URL="http://muchtodo-alb-final-425877782.us-east-1.elb.amazonaws.com"
FRONTEND_URL="http://muchtodo-frontend-dev.s3-website-us-east-1.amazonaws.com"

echo "Checking backend..."
BACKEND_STATUS=$(curl -s -o /dev/null -w "%{http_code}" $BACKEND_URL)
if [ $BACKEND_STATUS -eq 200 ]; then
  echo "Backend is healthy - Status: $BACKEND_STATUS"
else
  echo "Backend is unhealthy - Status: $BACKEND_STATUS"
fi

echo "Checking frontend..."
FRONTEND_STATUS=$(curl -s -o /dev/null -w "%{http_code}" $FRONTEND_URL)
if [ $FRONTEND_STATUS -eq 200 ]; then
  echo "Frontend is healthy - Status: $FRONTEND_STATUS"
else
  echo "Frontend is unhealthy - Status: $FRONTEND_STATUS"
fi

echo "Health checks complete!"