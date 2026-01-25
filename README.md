# Flower Helm Charts

This repository contains Helm charts for various applications.

## Structure

Each chart should be placed in its own directory with the following structure:

```
chart-name/
├── Chart.yaml
├── values.yaml
├── templates/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ...
└── README.md
```

## Usage

To package a chart:
```bash
helm package <chart-name>
```

To install a chart:
```bash
helm install <release-name> <chart-name>
```
