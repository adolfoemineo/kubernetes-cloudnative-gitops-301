# Starters y soluciones — mapa completo (rama `main` / Python)

## Scripts

| Script | Uso |
|--------|-----|
| `./scripts/lab-prepare.sh <lab>` | Restaura punto de partida |
| `./scripts/lab-verify.sh <lab>` | Comprueba lab completado |
| `./scripts/lab-solution.sh <lab>` | Copia solución (formador) |

## Matriz por laboratorio

| Lab | Starter | Solución |
|-----|---------|----------|
| M02-01 | `api.m01.py` | `api.m02-01.py` |
| M02-02 | `Dockerfile.m01` | `Dockerfile.m02-02` |
| M03-01 | `infra/k8s/starters/m03-01/` | `infra/k8s/solutions/m03-01/` |
| M03-02 | Solución M03-01 en `infra/k8s/base/` | (mismo) |
| M03-03 | M03-01 + `postgres.yaml` starter | `m03-03/postgres-statefulset.yaml` |
| M04-01 | `infra/helm/starters/` | `infra/helm/solutions/` |
| M04-02 | Chart sin `values-dev`/`staging` | `values-*.yaml` en solutions |
| M04-03 | `infra/kustomize/starters/` | `infra/kustomize/solutions/` |
| M05-01 | Sin workflows activos | `.github/workflows/solutions/` |
| M06-01 | `infra/argocd/starters/` | `infra/argocd/solutions/` |
| M08-02 | `observability/starters/` | ELK en solutions |
| M08-03 | — | `observability/solutions/` completo |

Rama **`springboot`**: stack Spring Boot + Angular.
