# Infraestructura de laboratorio

Entorno de prácticas para **Kubernetes + Docker Avanzado**: aplicación demo, clúster **kind** y stacks auxiliares según el módulo.

## Arranque rápido (M01)

```bash
./scripts/kind-up.sh          # clúster Kubernetes local
./scripts/lab-up.sh           # stack demo en Docker Compose
./scripts/health-check.sh
```

## Componentes

| Ruta | Uso |
|------|-----|
| `app/api/` | API Flask (config externalizada desde M02) |
| `app/web/` | Frontend nginx |
| `docker-compose.yml` | Stack local M01–M02 |
| `.env.example` | Plantilla de variables (copiar a `.env`, gitignored) |
| `kind/cluster-config.yaml` | Clúster `cloudnative-lab` |
| `k8s/` | Manifests base (M03+) |
| `scripts/kind-up.sh` / `kind-down.sh` | Crear/destruir clúster |
| `scripts/lab-up.sh` / `lab-down.sh` | Stack Compose |
| `scripts/image-size-compare.sh` | Comparar Dockerfile legacy vs multistage (M02) |
| `scripts/health-check.sh` | Docker, kind, herramientas y endpoints |

## Servicios (Compose)

| Servicio | Puerto | Rol |
|----------|--------|-----|
| `demo-web` | 8080 | Frontend estático |
| `demo-api` | 8081 | API de lab |
| `postgres` | 5432 | Base de datos |
| `redis` | 6379 | Cache / contador hits |
| `loadgen` | — | Tráfico periódico a `/work` |

## Requisitos

- GitHub Codespace con Docker (`.devcontainer`)
- ~8 GB RAM recomendados (kind + observabilidad en M08)
- Acceso saliente a GHCR y Docker Hub (M05+)
