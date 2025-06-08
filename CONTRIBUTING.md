# Contributing to K3s Jupyter Environments

## Development Setup

### Prerequisites
- ARM64 machine or emulator
- Docker with buildx support
- Access to K3s cluster
- Python 3.11+

### Local Development

1. Clone the repository:
```bash
git clone git@github.com:INworldR/k3s-jupyter-environments.git
cd k3s-jupyter-environments
```

2. Create a virtual environment:
```bash
python -m venv venv
source venv/bin/activate
```

3. Install development dependencies:
```bash
pip install -r requirements-dev.txt
```

## Adding New Environments

### 1. Create Environment Definition

Create a new directory under `environments/`:
```bash
mkdir -p environments/your-env/{notebooks,scripts,tools-config}
```

Create `environment.yml`:
```yaml
name: jupyter-yourenv
channels:
  - conda-forge
dependencies:
  - python=3.11
  - pip
  - ipykernel
  # Add your packages
```

### 2. Create Dockerfile

Create `docker/Dockerfile.yourenv`:
```dockerfile
FROM k3s-jupyter-base:latest
# Add your customizations
```

### 3. Update Build Matrix

Add your environment to `docker/build-matrix.yml`.

### 4. Test Locally

```bash
docker buildx build -f docker/Dockerfile.yourenv -t test-env .
docker run -it --rm test-env jupyter --version
```

## Testing

### Unit Tests
```bash
pytest tests/
```

### Integration Tests
```bash
./scripts/test-integration.sh
```

### ARM64 Compatibility
Always test on actual ARM64 hardware before submitting PR.

## Code Standards

### Python
- Follow PEP 8
- Use type hints
- Document all functions

### Docker
- Multi-stage builds
- Minimize layers
- Security scan all images

### Kubernetes
- Use resource limits
- Follow security best practices
- Test on K3s

## Pull Request Process

1. Fork the repository
2. Create feature branch
3. Make changes
4. Test thoroughly
5. Update documentation
6. Submit PR

## Security

- Never commit secrets
- Scan images for vulnerabilities
- Follow least privilege principle
- Isolate dangerous tools

## Questions?

Open an issue or contact the maintainers.