# K3s Jupyter Environments

Security Analysis & Data Science environments for JupyterHub on Raspberry Pi K3s cluster.

## Overview

This repository provides specialized Jupyter environments optimized for ARM64 architecture, designed to run on a Raspberry Pi 5 K3s cluster. Each environment is tailored for specific use cases in security analysis and data science.

## Environments

### 1. Security Analysis
Network analysis, packet capture, and forensics tools integrated with Security Onion.

### 2. Data Science  
Machine learning and statistical analysis with optimized libraries for ARM64.

### 3. Malware Analysis
Static and dynamic analysis tools for malware research in isolated environments.

### 4. Penetration Testing
Web application and network penetration testing integrated with Kali Linux tools.

## Quick Start

```bash
# Clone on cluster node
git clone git@github.com:INworldR/k3s-jupyter-environments.git
cd k3s-jupyter-environments

# Initial setup
./scripts/setup-cluster.sh

# Build all environments
./scripts/build-images.sh

# Deploy to K3s
./scripts/deploy-to-k3s.sh
```

## Architecture

- **Platform**: ARM64 (Raspberry Pi 5)
- **Container Runtime**: containerd
- **Base Image**: Ubuntu 22.04 ARM64
- **Python**: Miniforge3 (conda-forge for ARM64)
- **Storage**: NFS persistent volumes

## Resource Requirements

Each environment is optimized for:
- **CPU**: 1-2 cores per user
- **Memory**: 2-4GB per user session
- **Storage**: 10GB per environment base

## Integration

### JupyterHub
Environments auto-register as kernels in JupyterHub with proper resource limits.

### GitLab CI/CD
Automated builds and deployments via GitLab pipelines on cn3.

### Monitoring
Prometheus metrics and Grafana dashboards track environment usage.

## Development

See [CONTRIBUTING.md](CONTRIBUTING.md) for development guidelines.

## License

MIT License - See [LICENSE](LICENSE) for details.
