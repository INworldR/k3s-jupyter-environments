#!/bin/bash
# Setup script for Security Analysis environment

set -e

echo "Setting up Security Analysis environment for ARM64..."

# Activate environment
source /opt/conda/etc/profile.d/conda.sh
conda activate jupyter-security

# Install system dependencies for security tools
sudo apt-get update && sudo apt-get install -y \
    libpcap-dev \
    libssl-dev \
    libffi-dev \
    tcpdump \
    tshark \
    nmap \
    whois \
    dnsutils \
    net-tools \
    gcc \
    g++ \
    make

# Install additional Python packages that need compilation
pip install --no-binary :all: --compile \
    pypcap \
    python-ptrace

# Register kernel
python -m ipykernel install \
    --name security \
    --display-name "Security Analysis" \
    --prefix=/opt/conda/envs/jupyter-security

# Create useful directories
mkdir -p ~/notebooks/security/{pcaps,logs,reports,scripts}

# Download useful security notebooks
cd ~/notebooks/security
if [ ! -d "security-notebooks" ]; then
    git clone https://github.com/jupyterhub/security-notebooks.git examples || true
fi

echo "Security Analysis environment setup complete!"