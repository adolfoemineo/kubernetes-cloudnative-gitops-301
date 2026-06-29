#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
API_DIR="$ROOT/infra/app/api"
LEGACY_TAG="cloudnative-demo-api:legacy"
OPTIMIZED_TAG="cloudnative-demo-api:optimized"

echo "== Construyendo Dockerfile.legacy =="
docker build -f "$API_DIR/Dockerfile.legacy" -t "$LEGACY_TAG" "$API_DIR"

echo "== Construyendo Dockerfile (multistage) =="
docker build -f "$API_DIR/Dockerfile" -t "$OPTIMIZED_TAG" "$API_DIR"

legacy_size="$(docker image inspect "$LEGACY_TAG" --format='{{.Size}}')"
optimized_size="$(docker image inspect "$OPTIMIZED_TAG" --format='{{.Size}}')"

legacy_mb="$(echo "scale=1; $legacy_size / 1024 / 1024" | bc)"
optimized_mb="$(echo "scale=1; $optimized_size / 1024 / 1024" | bc)"
saved_mb="$(echo "scale=1; ($legacy_size - $optimized_size) / 1024 / 1024" | bc)"

legacy_layers="$(docker history "$LEGACY_TAG" --format '{{.CreatedBy}}' | grep -vc '^$' || true)"
optimized_layers="$(docker history "$OPTIMIZED_TAG" --format '{{.CreatedBy}}' | grep -vc '^$' || true)"

echo
echo "| Imagen    | Tag        | Tamaño (MB) | Capas (aprox.) |"
echo "|-----------|------------|-------------|----------------|"
printf "| legacy    | %-10s | %11s | %14s |\n" "$LEGACY_TAG" "$legacy_mb" "$legacy_layers"
printf "| multistage| %-10s | %11s | %14s |\n" "$OPTIMIZED_TAG" "$optimized_mb" "$optimized_layers"
echo
echo "Ahorro aproximado: ${saved_mb} MB"
