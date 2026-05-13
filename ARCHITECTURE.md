# System Architecture

## Overview

The StartTech application is a full-stack task management system deployed on AWS. The architecture is designed for scalability, reliability and automated deployments.

## Architecture Diagram
Internet
|
CloudFront CDN
|
S3 (Frontend)     ALB (Load Balancer)
|
EC2 Instance
(Golang API)
/          
MongoDB Atlas    ElastiCache Redis

## Components

### Frontend Layer
- React application built and deployed to S3
- CloudFront serves the static files globally with low latency
- S3 bucket is configured for static website hosting

### Backend Layer
- Golang API running inside a Docker container on EC2
- Application Load Balancer distributes traffic and performs health checks
- EC2 instance is in a public subnet with security groups restricting access

### Data Layer
- MongoDB Atlas handles all application data persistence
- ElastiCache Redis handles session caching and frequently accessed data

### CI/CD Layer
- GitHub Actions automates all deployments
- Frontend changes trigger automatic S3 deployment
- Backend changes trigger Docker build, ECR push and EC2 deployment

### Security
- IAM roles follow least privilege principle
- Security groups restrict traffic to necessary ports only
- Secrets managed via GitHub Actions secrets
- EC2 access restricted to SSH key authentication
