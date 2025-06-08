#!/bin/bash
# Build all Jupyter environment images for ARM64

set -e

REGISTRY="${REGISTRY:-localhost:5000}"
TAG="${TAG:-latest}"

echo "Building Jupyter environments for ARM64..."
echo "Registry: $REGISTRY"
echo "Tag: $TAG"

# Change to docker directory
cd "$(dirname "$0")/../docker"

# Build base image first
echo "Building base image..."
docker buildx build \
  --platform linux/arm64 \
  -t k3s-jupyter-base:$TAG \
  -t $REGISTRY/k3s-jupyter-base:$TAG \
  -f Dockerfile.base \
  --push \
  ..

# Build environment images
for env in security datascience malware pentesting; do
  echo "Building $env environment..."
  docker buildx build \
    --platform linux/arm64 \
    -t k3s-jupyter-$env:$TAG \
    -t $REGISTRY/k3s-jupyter-$env:$TAG \
    -f Dockerfile.$env \
    --build-arg BASE_IMAGE=k3s-jupyter-base:$TAG \
    --push \
    ..
done

echo "All images built and pushed successfully!"

# List images
echo "Available images:"
docker images | grep k3s-jupyter