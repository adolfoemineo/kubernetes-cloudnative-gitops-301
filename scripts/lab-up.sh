#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
COMPOSE="$ROOT/infra/docker-compose.yml"
ENV_FILE="$ROOT/infra/.env"

if [[ ! -f "$ENV_FILE" ]]; then
  cp "$ROOT/infra/.env.example" "$ENV_FILE"
fi

docker compose -f "$COMPOSE" up -d --build
"$ROOT/scripts/health-check.sh"
