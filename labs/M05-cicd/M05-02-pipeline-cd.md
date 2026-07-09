# M05-02 — Pipeline de despliegue

[← Página anterior](M05-01-pipeline-ci.md) · [Siguiente página →](../M06-gitops-argocd/README.md)

## Objetivo

Encadenar CI → CD: tras el build, desplegar el chart Helm con la imagen versionada.

## Prerrequisitos

- M05-01 (CI publicando en GHCR).

## Antes de empezar

```bash
./scripts/lab-prepare.sh m05-02
```

Referencia: `.github/workflows/solutions/cd.yml`.

---

### 1 — Parametrizar Helm con imagen CI

En `values.yaml` del chart:

```yaml
api:
  image: ghcr.io/TU_USUARIO/TU_REPO/demo-api:latest
web:
  image: ghcr.io/TU_USUARIO/TU_REPO/demo-web:latest
```

O pasa `--set api.image=...` en el job de deploy.

---

### 2 — Job deploy (Codespace / manual)

En Codespace con kind:

```bash
# Tras pull de imágenes desde GHCR (o build local)
./scripts/helm-install.sh cloudnative-demo cloudnative-lab \
  --set api.image=ghcr.io/.../demo-api:SHA
```

Workflow CD puede hacer `helm upgrade` contra un clúster remoto; en el curso validas con `helm lint` + install local.

---

### 3 — Crear cd.yml

Basado en la solución: trigger en cambios de `infra/helm/cloudnative-demo/**`.

---

### 4 — Verificar release

```bash
helm list -n cloudnative-lab
kubectl -n cloudnative-lab get pods -o jsonpath='{.items[*].spec.containers[*].image}'
```

**Resultado esperado:** Imágenes apuntan al tag del pipeline CI.

---

→ **[M06 — GitOps](../M06-gitops-argocd/README.md)**

```bash
./scripts/lab-verify.sh m05-02
```
