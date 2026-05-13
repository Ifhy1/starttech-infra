#!/bin/bash

echo "Deploying frontend to S3..."

cd frontend
npm install
npm run build

aws s3 sync dist/ s3://muchtodo-frontend-dev --delete

aws cloudfront create-invalidation \
  --distribution-id E28UJ83TH7FXYA \
  --paths "/*"

echo "Frontend deployed successfully!"