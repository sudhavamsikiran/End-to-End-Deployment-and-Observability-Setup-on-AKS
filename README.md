## Security Checks

This repository implements Shift Left Security principles to ensure code security and integrity from the early stages of development. The following security checks are integrated into the GitHub Actions CI/CD pipeline:

1. **Secret Scanning**: Scans the codebase for any exposed secrets.
   - If secrets are detected, the pipeline will block deployment and fail the build.

2. **Code Security Analysis**: Uses GitHub CodeQL to analyze the code for vulnerabilities.
   - If vulnerabilities are detected, the pipeline will block deployment and fail the build.

### Actions Taken if Vulnerabilities or Secrets are Detected:
- The pipeline will automatically fail.
- The developer is required to address the detected issues before a successful build and deployment can proceed.
