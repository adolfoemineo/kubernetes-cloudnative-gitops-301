#!/usr/bin/env bash
# Copia la solución de referencia (formador / recuperación).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LAB="${1:-}"

usage() {
  cat <<'EOF'
Uso: ./scripts/lab-solution.sh <lab>

Labs: m02-01 m02-02 m03-01 m03-03 m04-01 m04-02 m04-03
      m05-01 m05-02 m06-02 m06-03 m08-03
EOF
}

copy_tree() { rm -rf "$2"; mkdir -p "$(dirname "$2")"; cp -a "$1" "$2"; echo "→ $2"; }

case "$LAB" in
  m02-01)
    cp "$ROOT/infra/solutions/api.m02-01.py" "$ROOT/infra/app/api/api.py"
    ;;
  m02-02)
    cp "$ROOT/infra/solutions/Dockerfile.m02-02" "$ROOT/infra/app/api/Dockerfile"
    ;;
  m03-01)
    rm -rf "$ROOT/infra/k8s/base"
    mkdir -p "$ROOT/infra/k8s/base"
    cp -a "$ROOT/infra/k8s/solutions/m03-01/." "$ROOT/infra/k8s/base/"
    ;;
  m03-03)
    cp "$ROOT/infra/k8s/solutions/m03-03/postgres-statefulset.yaml" "$ROOT/infra/k8s/base/postgres.yaml"
    ;;
  m04-01|m04-02)
    copy_tree "$ROOT/infra/helm/solutions/cloudnative-demo" "$ROOT/infra/helm/cloudnative-demo"
    mkdir -p "$ROOT/infra/helm/environments"
    cp "$ROOT/infra/helm/solutions/environments/values-dev.yaml" "$ROOT/infra/helm/environments/" 2>/dev/null || true
    cp "$ROOT/infra/helm/solutions/environments/values-staging.yaml" "$ROOT/infra/helm/environments/" 2>/dev/null || true
    ;;
  m04-03)
    rm -rf "$ROOT/infra/kustomize/base" "$ROOT/infra/kustomize/overlays"
    mkdir -p "$ROOT/infra/kustomize/overlays"
    cp -a "$ROOT/infra/kustomize/solutions/base" "$ROOT/infra/kustomize/base"
    cp -a "$ROOT/infra/kustomize/solutions/overlays/dev" "$ROOT/infra/kustomize/overlays/dev"
    cp -a "$ROOT/infra/kustomize/solutions/overlays/staging" "$ROOT/infra/kustomize/overlays/staging"
    ;;
  m05-01)
    mkdir -p "$ROOT/.github/workflows"
    cp "$ROOT/.github/workflows/solutions/ci.yml" "$ROOT/.github/workflows/ci.yml"
    ;;
  m05-02)
    cp "$ROOT/.github/workflows/solutions/cd.yml" "$ROOT/.github/workflows/cd.yml"
    ;;
  m06-02)
    cp "$ROOT/infra/argocd/solutions/application-dev.yaml" "$ROOT/infra/argocd/application-dev.yaml"
    ;;
  m06-03)
    cp "$ROOT/infra/argocd/solutions/application-dev.yaml" "$ROOT/infra/argocd/application-dev.yaml"
    cp "$ROOT/infra/argocd/solutions/application-staging.yaml" "$ROOT/infra/argocd/application-staging.yaml"
    ;;
  m08-03)
    rm -rf "$ROOT/infra/observability/active"
    mkdir -p "$ROOT/infra/observability/active"
    cp -a "$ROOT/infra/observability/solutions/." "$ROOT/infra/observability/active/"
    ;;
  *)
    usage
    exit 1
    ;;
esac
echo "OK: solución $LAB copiada."
