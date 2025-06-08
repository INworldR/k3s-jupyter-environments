#!/bin/bash
# Initial setup script for K3s Jupyter environments

set -e

echo "Setting up K3s cluster for Jupyter environments..."

# Check if running on cluster node
if ! hostname | grep -q "cn[1-4]"; then
  echo "This script should be run on a cluster node (cn1-cn4)"
  exit 1
fi

# Install required tools
echo "Installing required tools..."
sudo apt-get update
sudo apt-get install -y \
  docker.io \
  docker-buildx \
  git \
  curl \
  jq

# Setup Docker buildx for multi-arch
docker buildx create --name k3s-builder --use || true
docker buildx inspect --bootstrap

# Create local registry if not exists
if ! docker ps | grep -q registry; then
  echo "Creating local Docker registry..."
  docker run -d \
    --restart=always \
    --name registry \
    -p 5000:5000 \
    -v /srv/registry:/var/lib/registry \
    registry:2
fi

# Configure K3s to use local registry
echo "Configuring K3s for local registry..."
cat <<EOF | sudo tee /etc/rancher/k3s/registries.yaml
mirrors:
  "localhost:5000":
    endpoint:
      - "http://localhost:5000"
EOF

# Restart K3s to apply registry config
sudo systemctl restart k3s

# Install Helm if not present
if ! command -v helm &> /dev/null; then
  echo "Installing Helm..."
  curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

# Create required directories
echo "Creating directories..."
sudo mkdir -p /srv/nfs/k8s-data/{jupyter-shared,jupyter-datasets,jupyter-environments}
sudo chown -R 1000:1000 /srv/nfs/k8s-data/jupyter-*

# Clone example notebooks
echo "Cloning example notebooks..."
cd /srv/nfs/k8s-data/jupyter-shared
git clone https://github.com/jupyter/jupyter-examples.git examples || true

# Download sample datasets
echo "Downloading sample datasets..."
cd /srv/nfs/k8s-data/jupyter-datasets
wget -q https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data || true
wget -q https://raw.githubusercontent.com/mwaskom/seaborn-data/master/titanic.csv || true

echo "Cluster setup complete!"
echo ""
echo "Next steps:"
echo "1. Build images: ./build-images.sh"
echo "2. Deploy JupyterHub: ./deploy-to-k3s.sh"