#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LAB="${1:-}"
API="$ROOT/infra/app/api/api.py"
DOCKERFILE="$ROOT/infra/app/api/Dockerfile"

usage() {
  cat <<'EOF'
Uso: ./scripts/lab-verify.sh <lab>

  m02-01  m02-02  m03-01  m03-02  m03-03
  m04-01  m04-02  m04-03
  m05-01  m05-02
  m06-01  m06-02  m06-03
  m08-01  m08-02  m08-03
EOF
}

ok()   { echo "OK: $*"; }
fail() { echo "FALTA: $*" >&2; errors=$((errors + 1)); }

errors=0

case "$LAB" in
  m02-01)
    echo "== M02-01 =="
    grep -q 'os\.environ' "$API" || fail "api.py sin os.environ"
    grep -q 'def ready' "$API" || fail "falta /ready"
    grep -q 'postgres://lab:lab@postgres' "$API" && fail "DATABASE_URL hardcodeada"
    ;;
  m02-02)
    echo "== M02-02 =="
    grep -q 'AS builder' "$DOCKERFILE" || fail "sin multistage builder"
    grep -q 'USER app' "$DOCKERFILE" || fail "sin USER app"
    ;;
  m03-01)
    echo "== M03-01 =="
    for f in namespace.yaml api-deployment.yaml api-service.yaml web-deployment.yaml web-service.yaml api-configmap.yaml api-secret.yaml redis.yaml; do
      [[ -f "$ROOT/infra/k8s/base/$f" ]] || fail "falta $f"
    done
    grep -q 'path: /ready' "$ROOT/infra/k8s/base/api-deployment.yaml" 2>/dev/null || fail "falta readinessProbe /ready"
    ;;
  m03-02)
    echo "== M03-02 =="
    kubectl -n cloudnative-lab get deploy demo-api &>/dev/null || fail "deployment demo-api no encontrado"
    ;;
  m03-03)
    echo "== M03-03 =="
    [[ -f "$ROOT/infra/k8s/base/postgres.yaml" ]] || fail "falta postgres.yaml"
    grep -q 'StatefulSet' "$ROOT/infra/k8s/base/postgres.yaml" || fail "postgres sin StatefulSet"
    ;;
  m04-01)
    echo "== M04-01 =="
    [[ -f "$ROOT/infra/helm/cloudnative-demo/Chart.yaml" ]] || fail "falta Chart.yaml"
    [[ -f "$ROOT/infra/helm/cloudnative-demo/templates/api.yaml" ]] || fail "falta templates/api.yaml"
    ;;
  m04-02)
    echo "== M04-02 =="
    [[ -f "$ROOT/infra/helm/cloudnative-demo/values-dev.yaml" ]] || fail "falta values-dev.yaml"
    ;;
  m04-03)
    echo "== M04-03 =="
    [[ -f "$ROOT/infra/kustomize/overlays/dev/kustomization.yaml" ]] || fail "falta overlay dev"
    [[ -f "$ROOT/infra/kustomize/overlays/staging/kustomization.yaml" ]] || fail "falta overlay staging"
    ;;
  m05-01)
    echo "== M05-01 =="
    [[ -f "$ROOT/.github/workflows/ci.yml" ]] || fail "falta .github/workflows/ci.yml"
    grep -q 'infra/app/api' "$ROOT/.github/workflows/ci.yml" || fail "CI no construye API"
    ;;
  m05-02)
    echo "== M05-02 =="
    [[ -f "$ROOT/.github/workflows/cd.yml" ]] || fail "falta cd.yml"
    ;;
  m06-01)
    echo "== M06-01 =="
    [[ -f "$ROOT/infra/argocd/application-dev.yaml" ]] || fail "falta application-dev.yaml"
    grep -q 'argoproj.io/v1alpha1' "$ROOT/infra/argocd/application-dev.yaml" || fail "manifest ArgoCD inválido"
    ;;
  m06-02)
    echo "== M06-02 =="
    grep -q 'automated:' "$ROOT/infra/argocd/application-dev.yaml" || fail "falta syncPolicy.automated"
    ;;
  m06-03)
    echo "== M06-03 =="
    [[ -f "$ROOT/infra/argocd/application-staging.yaml" ]] || fail "falta application-staging.yaml"
    ;;
  m08-01|m08-02|m08-03)
    echo "== $LAB =="
    [[ -d "$ROOT/infra/observability/active" ]] && ls "$ROOT/infra/observability/active"/*.yaml &>/dev/null \
      || fail "falta manifests en infra/observability/active/"
    if [[ "$LAB" == "m08-03" ]]; then
      [[ -f "$ROOT/infra/observability/active/prometheus.yaml" ]] || fail "falta prometheus.yaml"
    fi
    ;;
  -h|--help|"")
    usage
    exit "${1:+0}"
    ;;
  *)
    echo "Lab desconocido: $LAB" >&2
    usage
    exit 1
    ;;
esac

[[ "$errors" -eq 0 ]] && ok "$LAB verificado"
exit "$errors"
