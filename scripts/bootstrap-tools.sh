#!/usr/bin/env bash
set -euo pipefail

# kind (no incluido en la feature kubectl-helm-minikube por defecto)
if ! command -v kind >/dev/null 2>&1; then
  curl -fsSL "https://kind.sigs.k8s.io/dl/v0.27.0/kind-linux-amd64" -o /tmp/kind
  sudo install -m 0755 /tmp/kind /usr/local/bin/kind
fi

# kustomize
if ! command -v kustomize >/dev/null 2>&1; then
  curl -fsSL "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv5.6.0/kustomize_v5.6.0_linux_amd64.tar.gz" \
    | sudo tar -xz -C /usr/local/bin kustomize
fi

echo "Herramientas listas: docker, kubectl, helm, kind, kustomize"
