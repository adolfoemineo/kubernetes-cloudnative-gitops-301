# M06-02 — Sincronización automática

[← Página anterior](M06-01-intro-gitops.md) · [Siguiente página →](M06-03-promocion-entornos.md)

## Objetivo

Configurar **sync automático** y `selfHeal` para que el clúster refleje Git sin `kubectl apply` manual.

## Antes de empezar

```bash
./scripts/lab-prepare.sh m06-02
```

---

### 1 — syncPolicy

En tu Application:

```yaml
syncPolicy:
  automated:
    prune: true
    selfHeal: true
```

**Por qué:** Cambios en Git se aplican solos; drift manual se revierte.

---

### 2 — Prueba de selfHeal

```bash
kubectl -n cloudnative-lab scale deployment demo-api --replicas=5
# Espera — ArgoCD vuelve al valor del manifest en Git
```

---

### 3 — Prueba de prune

Elimina un recurso del overlay en Git y haz push — ArgoCD debe borrarlo del clúster si `prune: true`.

---

→ **[M06-03 — Promoción entre entornos](M06-03-promocion-entornos.md)**

```bash
./scripts/lab-verify.sh m06-02
```
