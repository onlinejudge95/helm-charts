#!/bin/bash
set -e

# Script to package all Helm charts in the repository

CHARTS_DIR="charts"
PACKAGES_DIR="packages"

# Create packages directory if it doesn't exist
mkdir -p "$PACKAGES_DIR"

# Package each chart
for chart in "$CHARTS_DIR"/*; do
    if [ -d "$chart" ] && [ -f "$chart/Chart.yaml" ]; then
        echo "Packaging $(basename "$chart")..."
        helm package "$chart" -d "$PACKAGES_DIR"
    fi
done

# Generate/update the index
echo "Generating Helm repository index..."
helm repo index "$PACKAGES_DIR" --url https://onlinejudge95.github.io/helm-charts

echo "Done! Charts packaged in $PACKAGES_DIR/"
