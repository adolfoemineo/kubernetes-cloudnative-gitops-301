#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CHART="$ROOT/infra/helm/cloudnative-demo"
RELEASE="${1:-cloudnative-demo}"
NAMESPACE="${2:-cloudnative-lab}"

# -n fija .Release.Namespace en todos los templates (no uses namespace: en values.yaml).
# --create-namespace: crea el ns solo si no existe (en el curso M03 ya existe cloudnative-lab).
helm upgrade --install "$RELEASE" "$CHART" \
  --namespace "$NAMESPACE" \
  --create-namespace \
  "${@:3}"
