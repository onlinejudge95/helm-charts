# Helm Charts

A multi-chart Helm repository for deploying various applications.

## Repository Structure

```
flower-helm/
├── charts/                    # All Helm charts go here
│   ├── chart-1/
│   │   ├── Chart.yaml
│   │   ├── values.yaml
│   │   ├── templates/
│   │   └── README.md
│   └── chart-2/
│       └── ...
├── scripts/                   # Utility scripts
│   ├── package-charts.sh     # Package all charts
│   └── lint-charts.sh        # Lint all charts
├── packages/                  # Generated chart packages (gitignored)
├── .github/workflows/        # CI/CD workflows
│   ├── ci.yml                # Continuous integration (tests, linting)
│   └── cd.yml                # Continuous delivery/deployment
├── ct.yaml                   # Chart testing configuration
└── .helmignore               # Files to ignore in packages

```

## Adding a New Chart

1. Create a new directory under `charts/`:
   ```bash
   mkdir -p charts/my-app
   cd charts/my-app
   ```

2. Initialize the chart:
   ```bash
   helm create .
   ```

3. Customize the chart files:
   - `Chart.yaml` - Chart metadata
   - `values.yaml` - Default configuration values
   - `templates/` - Kubernetes manifests
   - `README.md` - Chart-specific documentation

4. Follow the standard Helm chart structure:
   ```
   my-app/
   ├── Chart.yaml
   ├── values.yaml
   ├── templates/
   │   ├── NOTES.txt
   │   ├── _helpers.tpl
   │   ├── deployment.yaml
   │   ├── service.yaml
   │   ├── ingress.yaml
   │   └── ...
   └── README.md
   ```

## Development Workflow

### Linting Charts

Lint all charts to ensure they follow best practices:
```bash
./scripts/lint-charts.sh
```

Or lint a specific chart:
```bash
helm lint charts/my-app
```

### Testing Charts

Test rendering templates locally:
```bash
helm template my-release charts/my-app
```

Test with custom values:
```bash
helm template my-release charts/my-app -f custom-values.yaml
```

### Packaging Charts

Package all charts:
```bash
./scripts/package-charts.sh
```

Package a specific chart:
```bash
helm package charts/my-app -d packages/
```

## Using Charts from This Repository

### Add the Helm Repository

```bash
helm repo add flower-helm https://onlinejudge95.github.io/flower-helm/packages
helm repo update
```

### Install a Chart

```bash
helm install my-release flower-helm/my-app
```

### Install with Custom Values

```bash
helm install my-release flower-helm/my-app -f custom-values.yaml
```

### Upgrade a Release

```bash
helm upgrade my-release flower-helm/my-app
```

### Uninstall a Release

```bash
helm uninstall my-release
```

## CI/CD

This repository uses GitHub Actions for automated testing and releases:

- **Lint Workflow**: Runs on pull requests to validate chart changes
- **Release Workflow**: Automatically packages and publishes charts when changes are pushed to `main`

The release workflow uses [chart-releaser](https://github.com/helm/chart-releaser) to:
1. Package changed charts
2. Create GitHub releases
3. Update the Helm repository index
4. Publish to GitHub Pages

## Best Practices

1. **Versioning**: Follow [Semantic Versioning](https://semver.org/) in `Chart.yaml`
2. **Documentation**: Include a comprehensive README.md for each chart
3. **Values**: Provide sensible defaults in `values.yaml` with comments
4. **Templates**: Use `_helpers.tpl` for reusable template snippets
5. **Testing**: Test charts locally before committing
6. **Dependencies**: Declare chart dependencies in `Chart.yaml`

## Contributing

1. Create a new branch for your changes
2. Add or modify charts in the `charts/` directory
3. Lint your changes: `./scripts/lint-charts.sh`
4. Commit and push your changes
5. Open a pull request

## License

[Add your license information here]
