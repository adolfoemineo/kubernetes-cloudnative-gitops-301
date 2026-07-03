# M04-02 — Parametrización con Helm

[← Página anterior](M04-01-intro-helm.md) · [Siguiente página →](M04-03-kustomize.md)

## Objetivo

Parametrizar réplicas, nombres de servicio y recursos con `values.yaml` y overrides por línea de comandos.

## Antes de empezar

```bash
./scripts/lab-prepare.sh m04-02
```

Copia referencia: `cp infra/helm/solutions/values-dev.yaml infra/helm/cloudnative-demo/` y adapta.

### 1 — values por entorno

Crea `values-dev.yaml`:

```yaml
api:
  replicas: 1
config:
  serviceName: cloudnative-demo-api-dev
```

Crea `values-staging.yaml` con `replicas: 2` y otro `serviceName`.

---

### 2 — Upgrade con overrides

```bash
helm upgrade cloudnative-demo infra/helm/cloudnative-demo \
  -n cloudnative-lab \
  -f infra/helm/cloudnative-demo/values.yaml \
  -f values-dev.yaml
```

Verifica el ConfigMap generado:

```bash
kubectl -n cloudnative-lab get configmap demo-api-config -o yaml | grep SERVICE_NAME
```

---

### 3 — Historial y rollback Helm

```bash
helm history cloudnative-demo -n cloudnative-lab
helm rollback cloudnative-demo 1 -n cloudnative-lab
```

**Por qué:** Mismo concepto que `kubectl rollout`, pero a nivel de **release** Helm.

---

### 4 — Recursos y límites

Añade en values:

```yaml
api:
  resources:
    requests:
      cpu: 100m
      memory: 256Mi
    limits:
      memory: 512Mi
```

Template con `{{ .Values.api.resources }}` en el contenedor.

---

→ **[M04-03 — Kustomize](M04-03-kustomize.md)**

```bash
./scripts/lab-verify.sh m04-02
```
