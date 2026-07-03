#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CTX="${KUBE_CONTEXT:-kind-cloudnative-lab}"
ACTIVE="$ROOT/infra/observability/active"
SOL="$ROOT/infra/observability/solutions"
SRC="$SOL"
[[ -d "$ACTIVE" && -n "$(ls -A "$ACTIVE"/*.yaml 2>/dev/null)" ]] && SRC="$ACTIVE"

echo "== Observabilidad desde $SRC =="
kubectl --context "$CTX" apply -f "$SRC/namespace.yaml"
kubectl --context "$CTX" apply -f "$SRC/prometheus.yaml"
kubectl --context "$CTX" apply -f "$SRC/grafana.yaml"
[[ -f "$SRC/elasticsearch-kibana.yaml" ]] && kubectl --context "$CTX" apply -f "$SRC/elasticsearch-kibana.yaml"
echo "Prometheus :30090 | Grafana :30300 (admin/lab) | Kibana :30561"
