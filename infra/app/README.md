# Aplicación demo del curso

Stack mínima que evoluciona módulo a módulo:

| Componente | Ruta | Rol |
|------------|------|-----|
| **API** | `api/` | Flask: `/health`, `/ready`, `/work`, `/slow`, `/fail` |
| **Web** | `web/` | nginx estático en puerto 8080 |
| **Compose** | `../docker-compose.yml` | Orquestación local M01–M02 |
| **Config** | `../.env.example` | Variables runtime (copiar a `.env`) |

## Estado por módulo

| Módulo | Cambio |
|--------|--------|
| M01 | Config embebida en código (exploración) |
| M02-01 | `os.environ`, `/ready`, `infra/.env` |
| M02-02 | `Dockerfile` multistage + `Dockerfile.legacy` para comparar |
| M03+ | Despliegue en kind (`infra/k8s/`) |

## Dockerfiles API

| Fichero | Uso |
|---------|-----|
| `Dockerfile` | **Producción** — multistage, usuario `app` |
| `Dockerfile.legacy` | Referencia M02-02 — monolítico para comparar tamaño |

## Arranque

```bash
cp infra/.env.example infra/.env   # si no existe
./scripts/lab-up.sh
curl -s http://127.0.0.1:8081/ready | jq .
./scripts/image-size-compare.sh    # M02-02
```
