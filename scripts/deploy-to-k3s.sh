#!/bin/bash
# Deploy JupyterHub with custom environments to K3s

set -e

NAMESPACE="jupyterhub"
RELEASE_NAME="jupyterhub"

echo "Deploying JupyterHub to K3s cluster..."

# Create namespace if it doesn't exist
kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

# Create NFS directories
echo "Setting up NFS directories..."
ssh cn1 "sudo mkdir -p /srv/nfs/k8s-data/{jupyter-shared,jupyter-datasets,jupyter-environments}"
ssh cn1 "sudo chown -R 1000:1000 /srv/nfs/k8s-data/jupyter-*"
ssh cn1 "sudo chmod 755 /srv/nfs/k8s-data/jupyter-*"

# Add JupyterHub Helm repository
helm repo add jupyterhub https://hub.jupyter.org/helm-chart/
helm repo update

# Generate secret token if not exists
if [ -z "$JUPYTERHUB_SECRET_TOKEN" ]; then
  export JUPYTERHUB_SECRET_TOKEN=$(openssl rand -hex 32)
  echo "Generated secret token: $JUPYTERHUB_SECRET_TOKEN"
fi

# Update custom values with secret token
sed -i "s/\$(openssl rand -hex 32)/$JUPYTERHUB_SECRET_TOKEN/g" ../kubernetes/jupyterhub/custom-values.yaml

# Deploy JupyterHub
helm upgrade --install $RELEASE_NAME jupyterhub/jupyterhub \
  --namespace $NAMESPACE \
  --values ../kubernetes/jupyterhub/custom-values.yaml \
  --timeout 10m \
  --wait

echo "JupyterHub deployed successfully!"

# Wait for pods to be ready
echo "Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=jupyterhub -n $NAMESPACE --timeout=300s

# Get service information
echo "JupyterHub service information:"
kubectl get svc -n $NAMESPACE

echo ""
echo "Access JupyterHub at: http://10.5.3.4"
echo "Username: admin"
echo "Password: picluster123"
echo ""
echo "To check deployment status:"
echo "kubectl get pods -n $NAMESPACE"