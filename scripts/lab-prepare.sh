#!/usr/bin/env bash
# Restaura el punto de partida de un laboratorio (stack Python / rama main).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LAB="${1:-}"

API_PY="$ROOT/infra/app/api/api.py"
API_DOCKERFILE="$ROOT/infra/app/api/Dockerfile"
K8S_BASE="$ROOT/infra/k8s/base"
HELM_CHART="$ROOT/infra/helm/cloudnative-demo"
KUSTOMIZE="$ROOT/infra/kustomize"
ARGOCD="$ROOT/infra/argocd"
WORKFLOWS="$ROOT/.github/workflows"
OBS="$ROOT/infra/observability"

usage() {
  cat <<'EOF'
Uso: ./scripts/lab-prepare.sh <lab>

App (M02):
  m02-01   api.py estado M01
  m02-02   api M02-01 + Dockerfile monolítico

Kubernetes (M03):
  m03-01   post-M02 + starters K8s en infra/k8s/base/
  m03-02   solución M03-01 en infra/k8s/base/ (rolling update)
  m03-03   M03-01 + esqueleto postgres.yaml

Helm / Kustomize (M04):
  m04-01   chart starter Helm
  m04-02   chart solución sin values-dev/staging
  m04-03   starters Kustomize

CI/CD (M05):
  m05-01   sin workflows activos
  m05-02   starter CI; añades CD

GitOps (M06):
  m06-01   starter ArgoCD
  m06-02   application-dev con sync automático
  m06-03   applications dev + staging

Observabilidad (M08):
  m08-01   app post-M02 lista
  m08-02   solo namespace en observability/active/
  m08-03   solución Prometheus + Grafana (+ ELK)

Rama main = Python/Flask. Rama springboot = Spring Boot + Angular.
EOF
}

copy_file() { cp "$1" "$2"; echo "  → $(realpath --relative-to="$ROOT" "$2")"; }
copy_tree() { rm -rf "$2"; mkdir -p "$(dirname "$2")"; cp -a "$1" "$2"; echo "  → $(realpath --relative-to="$ROOT" "$2")/"; }

prepare_app_post_m02() {
  copy_file "$ROOT/infra/solutions/api.m02-01.py" "$API_PY"
  copy_file "$ROOT/infra/solutions/Dockerfile.m02-02" "$API_DOCKERFILE"
}

copy_k8s_solution() {
  local src="$ROOT/infra/k8s/solutions/$1"
  rm -rf "$K8S_BASE"
  mkdir -p "$K8S_BASE"
  cp -a "$src/"* "$K8S_BASE/"
}

case "$LAB" in
  m02-01)
    echo "== M02-01 =="
    copy_file "$ROOT/infra/starters/api.m01.py" "$API_PY"
    ;;
  m02-02)
    echo "== M02-02 =="
    copy_file "$ROOT/infra/solutions/api.m02-01.py" "$API_PY"
    copy_file "$ROOT/infra/starters/Dockerfile.m01" "$API_DOCKERFILE"
    ;;
  m03-01)
    echo "== M03-01 =="
    prepare_app_post_m02
    rm -rf "$K8S_BASE"
    mkdir -p "$K8S_BASE"
    cp -a "$ROOT/infra/k8s/starters/m03-01/." "$K8S_BASE/"
    ;;
  m03-02)
    echo "== M03-02 =="
    prepare_app_post_m02
    copy_k8s_solution "m03-01"
    ;;
  m03-03)
    echo "== M03-03 =="
    prepare_app_post_m02
    copy_k8s_solution "m03-01"
    rm -f "$K8S_BASE/postgres.yaml" 2>/dev/null || true
    copy_file "$ROOT/infra/k8s/starters/m03-03/postgres.yaml" "$K8S_BASE/postgres.yaml"
    ;;
  m04-01)
    echo "== M04-01 =="
    prepare_app_post_m02
    copy_tree "$ROOT/infra/helm/starters/cloudnative-demo" "$HELM_CHART"
    ;;
  m04-02)
    echo "== M04-02 =="
    prepare_app_post_m02
    copy_tree "$ROOT/infra/helm/solutions/cloudnative-demo" "$HELM_CHART"
    rm -f "$HELM_CHART/values-dev.yaml" "$HELM_CHART/values-staging.yaml" 2>/dev/null || true
    ;;
  m04-03)
    echo "== M04-03 =="
    prepare_app_post_m02
    rm -rf "$KUSTOMIZE/base" "$KUSTOMIZE/overlays"
    mkdir -p "$KUSTOMIZE/overlays"
    cp -a "$ROOT/infra/kustomize/starters/base" "$KUSTOMIZE/base"
    cp -a "$ROOT/infra/kustomize/starters/overlays/dev" "$KUSTOMIZE/overlays/dev"
    cp -a "$ROOT/infra/kustomize/starters/overlays/staging" "$KUSTOMIZE/overlays/staging"
    ;;
  m05-01)
    echo "== M05-01 =="
    prepare_app_post_m02
    rm -f "$WORKFLOWS/ci.yml" "$WORKFLOWS/cd.yml"
    ;;
  m05-02)
    echo "== M05-02 =="
    prepare_app_post_m02
    mkdir -p "$WORKFLOWS"
    copy_file "$ROOT/.github/workflows/starters/ci.yml" "$WORKFLOWS/ci.yml"
    rm -f "$WORKFLOWS/cd.yml"
    ;;
  m06-01)
    echo "== M06-01 =="
    prepare_app_post_m02
    rm -f "$ARGOCD"/application-*.yaml 2>/dev/null || true
    copy_file "$ROOT/infra/argocd/starters/application-dev.yaml" "$ARGOCD/application-dev.yaml"
    ;;
  m06-02)
    echo "== M06-02 =="
    prepare_app_post_m02
    copy_file "$ROOT/infra/argocd/solutions/application-dev.yaml" "$ARGOCD/application-dev.yaml"
    ;;
  m06-03)
    echo "== M06-03 =="
    prepare_app_post_m02
    copy_file "$ROOT/infra/argocd/solutions/application-dev.yaml" "$ARGOCD/application-dev.yaml"
    copy_file "$ROOT/infra/argocd/solutions/application-staging.yaml" "$ARGOCD/application-staging.yaml"
    ;;
  m08-01)
    echo "== M08-01 =="
    prepare_app_post_m02
    ;;
  m08-02)
    echo "== M08-02 =="
    prepare_app_post_m02
    rm -rf "$OBS/active"
    mkdir -p "$OBS/active"
    copy_file "$ROOT/infra/observability/starters/namespace.yaml" "$OBS/active/namespace.yaml"
    ;;
  m08-03)
    echo "== M08-03 =="
    prepare_app_post_m02
    rm -rf "$OBS/active"
    mkdir -p "$OBS/active"
    cp -a "$ROOT/infra/observability/solutions/." "$OBS/active/"
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
echo "OK: $LAB preparado."
