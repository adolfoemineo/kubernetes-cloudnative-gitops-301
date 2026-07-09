# M06-03 — Promoción entre entornos

[← Página anterior](M06-02-sincronizacion-automatica.md) · [Siguiente página →](../M07-kubernetes-azure-aks/README.md)

## Objetivo

Modelar **dev → staging** con dos Applications ArgoCD y namespaces distintos.

## Antes de empezar

```bash
./scripts/lab-prepare.sh m06-03
```

---

### 1 — Overlay staging

Usa `infra/kustomize/solutions/overlays/staging/` como referencia.

Namespace destino: `cloudnative-lab-staging`.

---

### 2 — Segunda Application

`infra/argocd/solutions/application-staging.yaml` → copia y adapta `repoURL`.

```yaml
destination:
  namespace: cloudnative-lab-staging
source:
  path: infra/kustomize/overlays/staging
```

---

### 3 — Flujo de promoción

1. Validas en dev (PR + sync automático).
2. Merge a `main` con bump de imagen en overlay staging.
3. Sync staging (manual o automático según política).

**Por qué:** Git como auditoría; promoción = cambio de commit/values, no `kubectl` ad hoc.

---

→ **[M07 — AKS (referencia)](../M07-kubernetes-azure-aks/README.md)**

```bash
./scripts/lab-verify.sh m06-03
```
