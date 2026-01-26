# Contributing to Helm Charts

Thank you for your interest in contributing to this Helm chart repository!

## Getting Started

1. Fork the repository
2. Clone your fork locally
3. Create a new branch for your changes

## Adding or Modifying Charts

### Chart Requirements

- Follow the standard Helm chart structure
- Include a comprehensive `README.md` for each chart
- Use semantic versioning in `Chart.yaml`
- Provide well-documented default values in `values.yaml`
- Include helpful `NOTES.txt` for post-installation instructions

### Chart Structure

```
charts/my-app/
├── Chart.yaml          # Chart metadata (required)
├── values.yaml         # Default values (required)
├── README.md           # Chart documentation (required)
├── templates/          # Kubernetes manifests (required)
│   ├── NOTES.txt      # Post-install notes
│   ├── _helpers.tpl   # Template helpers
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ...
└── .helmignore        # Files to ignore (optional)
```

### Chart.yaml Example

```yaml
apiVersion: v2
name: my-app
description: A Helm chart for My Application
type: application
version: 0.1.0
appVersion: "1.0.0"
maintainers:
  - name: Your Name
    email: your.email@example.com
```

## Development Process

### 1. Lint Your Charts

Before committing, ensure your charts pass linting:

```bash
./scripts/lint-charts.sh
```

Or for a specific chart:

```bash
helm lint charts/my-app
```

### 2. Test Locally

Test template rendering:

```bash
helm template test-release charts/my-app
```

Test installation (requires a Kubernetes cluster):

```bash
helm install test-release charts/my-app --dry-run --debug
```

### 3. Update Documentation

- Update the chart's `README.md` with usage instructions
- Update the main repository `README.md` if adding a new chart
- Document any breaking changes

### 4. Version Bumping

Follow [Semantic Versioning](https://semver.org/):

- **MAJOR** version for incompatible API changes
- **MINOR** version for backwards-compatible functionality
- **PATCH** version for backwards-compatible bug fixes

Update both:
- `version` in `Chart.yaml` (chart version)
- `appVersion` in `Chart.yaml` (application version)

## Pull Request Process

1. Ensure all tests pass locally
2. Update documentation as needed
3. Commit your changes with clear, descriptive messages
4. Push to your fork
5. Open a pull request with:
   - Clear description of changes
   - Any breaking changes highlighted
   - Testing performed

## Code Review

All submissions require review. We use GitHub pull requests for this purpose.

## CI/CD

Your pull request will automatically trigger:
- Chart linting
- Template validation

Ensure all checks pass before requesting review.

## Questions?

Feel free to open an issue for any questions or concerns.
