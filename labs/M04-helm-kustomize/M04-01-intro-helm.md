# M04-01 — Introducción a Helm

[← Página anterior](README.md) · [Siguiente página →](M04-02-parametrizacion-helm.md)

## Objetivo

Crear un **chart Helm** para empaquetar la demo Spring Boot + Angular y sustituir los YAML sueltos de M03.

## Prerrequisitos

- M03 completado (manifests funcionando en kind).

## Antes de empezar

```bash
./scripts/lab-prepare.sh m04-01
```

Referencia: `infra/helm/solutions/cloudnative-demo/`.

## Mapa del ejercicio

```text
Paso 1   helm create + estructura del chart
Paso 2   Templates Deployment/Service API y Web
Paso 3   values.yaml con imágenes locales
Paso 4   helm install en kind
```

---

### 1 — Crear el chart

```bash
mkdir -p infra/helm
helm create infra/helm/cloudnative-demo
```

Elimina templates de ejemplo (nginx, etc.) y conserva `Chart.yaml`, `values.yaml`, `templates/`.

---

### 2 — Plantillas mínimas

Traslada tus manifests M03 a templates Helm con `{{ .Values.api.image }}`, `{{ .Values.namespace }}`, etc.

Archivos mínimos:

- `templates/namespace.yaml`
- `templates/api.yaml` (Deployment + Service)
- `templates/web.yaml`
- `templates/api-configmap.yaml`, `api-secret.yaml`
- `templates/redis.yaml`, `postgres.yaml` (opcional flags `.Values.redis.enabled`)

---

### 3 — values.yaml

```yaml
namespace: cloudnative-lab
api:
  image: cloudnative-demo-api:local
  replicas: 2
web:
  image: cloudnative-demo-web:local
  nodePort: 30080
```

---

### 4 — Instalar

```bash
helm lint infra/helm/cloudnative-demo
./scripts/helm-install.sh cloudnative-demo cloudnative-lab
kubectl -n cloudnative-lab get pods
./scripts/lab-verify.sh m04-01
```

---

## Comprueba tu entendimiento

**¿Helm vs YAML plano?**

→ Chart versionado, valores por entorno, releases con historial (`helm history`).

→ **[M04-02 — Parametrización](M04-02-parametrizacion-helm.md)**
