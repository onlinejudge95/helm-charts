#!/bin/bash
set -e

# Script to lint all Helm charts in the repository

CHARTS_DIR="charts"

echo "Linting Helm charts..."

for chart in "$CHARTS_DIR"/*; do
    if [ -d "$chart" ] && [ -f "$chart/Chart.yaml" ]; then
        echo "Linting $(basename "$chart")..."
        helm lint "$chart"
    fi
done

echo "All charts passed linting!"
