#!/bin/bash

# Variables
ACCOUNT_ID="622140367382"
REGION="us-west-2"
REPO_PREFIX="${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com"
SERVER_REPO_NAME="app"
IMAGE_TAG=`git rev-parse HEAD`

# Login to ECR
aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${REPO_PREFIX}

# Build and push the server image with a unique tag and 'latest'
cd server
docker build -t ${REPO_PREFIX}/${SERVER_REPO_NAME}:${IMAGE_TAG} .
docker push ${REPO_PREFIX}/${SERVER_REPO_NAME}:${IMAGE_TAG}
docker tag ${REPO_PREFIX}/${SERVER_REPO_NAME}:${IMAGE_TAG} ${REPO_PREFIX}/${SERVER_REPO_NAME}:latest
docker push ${REPO_PREFIX}/${SERVER_REPO_NAME}:latest
