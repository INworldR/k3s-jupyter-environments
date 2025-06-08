#!/bin/bash
# Sync Jupyter environments to cluster nodes

set -e

NODES=("cn1" "cn2" "cn3" "cn4")
REMOTE_PATH="/home/pi/k3s-jupyter-environments"

echo "Syncing Jupyter environments to cluster nodes..."

# Get current directory
LOCAL_PATH="$(cd "$(dirname "$0")/.." && pwd)"

# Sync to each node
for node in "${NODES[@]}"; do
  echo "Syncing to $node..."
  rsync -avz --delete \
    --exclude='.git' \
    --exclude='*.pyc' \
    --exclude='__pycache__' \
    --exclude='.DS_Store' \
    "$LOCAL_PATH/" \
    "$node:$REMOTE_PATH/"
done

# Make scripts executable on all nodes
for node in "${NODES[@]}"; do
  ssh $node "chmod +x $REMOTE_PATH/scripts/*.sh"
done

echo "Sync complete!"

# Show status
echo ""
echo "Environment status on nodes:"
for node in "${NODES[@]}"; do
  echo -n "$node: "
  ssh $node "ls -la $REMOTE_PATH/scripts/ | wc -l" || echo "Error"
done