## CI/CD Pipeline

This repository includes a CI/CD pipeline using GitHub Actions. The pipeline automates the following tasks:

1. **Linting**: Ensures code quality by running linters.
2. **Unit Testing**: Runs unit tests to verify application functionality.
3. **Containerization**: Builds a Docker image of the application.
4. **Security Scanning**: Integrates GitHub Advanced Security features like secret scanning and code security checks.
5. **Deployment**: Automatically deploys the containerized application to the AKS environment using Helm.

### Workflow Files

The workflow configuration can be found in the `.github/workflows/ci-cd-pipeline.yml` file.

### Secrets and Environment Variables

Ensure the following secrets are configured in the GitHub repository:
- `AZURE_CREDENTIALS`: Azure service principal credentials for AKS.
- `AKS_CLUSTER_NAME`: Name of the AKS cluster.
- `AKS_RESOURCE_GROUP`: Resource group of the AKS cluster.

### How It Works

1. **Linting and Testing**: On each push or pull request to the `main` branch, the workflow runs linting and unit tests.
2. **Building**: If the linting and tests pass, the workflow builds a Docker image and tags it with the commit SHA.
3. **Security Scanning**: Secret scanning and code security checks are performed.
4. **Deployment**: The Docker image is deployed to the AKS cluster using Helm.

This pipeline ensures that any changes to the `main` branch are thoroughly checked and automatically deployed, maintaining code quality and security.
