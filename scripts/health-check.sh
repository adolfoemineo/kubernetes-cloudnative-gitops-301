#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CLUSTER_NAME="cloudnative-lab"
CONTEXT="kind-${CLUSTER_NAME}"
COMPOSE="$ROOT/infra/docker-compose.yml"

fail=0

echo "== Docker =="
if docker info --format '{{.ServerVersion}}' >/dev/null 2>&1; then
  echo "OK: Docker operativo"
else
  echo "FALTA: Docker no responde"
  fail=1
fi

echo "== kind =="
if command -v kind >/dev/null 2>&1; then
  if kind get clusters 2>/dev/null | grep -qx "$CLUSTER_NAME"; then
    echo "OK: clúster $CLUSTER_NAME"
    kubectl cluster-info --context "$CONTEXT" 2>/dev/null || true
  else
    echo "AVISO: clúster no creado. Ejecuta ./scripts/kind-up.sh"
  fi
else
  echo "AVISO: kind no instalado. Ejecuta scripts/bootstrap-tools.sh"
fi

echo "== Herramientas =="
for cmd in kubectl helm kustomize; do
  if command -v "$cmd" >/dev/null 2>&1; then
    echo "OK: $cmd"
  else
    echo "FALTA: $cmd"
    fail=1
  fi
done

echo "== Stack demo (Compose) =="
if [[ -f "$COMPOSE" ]]; then
  for spec in "demo-web:8080" "demo-api:8081/health"; do
    svc="${spec%%:*}"
    target="${spec#*:}"
    host="${target%%/*}"
    path="/${target#*/}"
    [[ "$path" == "/$target" ]] && path=""
    url="http://127.0.0.1:${host}${path}"
    ok=0
    for _ in 1 2 3 4 5 6; do
      if curl -sf "$url" >/dev/null 2>&1; then
        ok=1
        break
      fi
      sleep 2
    done
    if [[ "$ok" -eq 1 ]]; then
      echo "OK: $svc :$host"
    else
      echo "AVISO: $svc :$host no responde (¿./scripts/lab-up.sh?)"
    fi
  done
fi

exit "$fail"
