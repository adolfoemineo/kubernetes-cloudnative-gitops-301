# M04-01 — Introducción a Helm

[← Página anterior](README.md) · [Siguiente página →](M04-02-parametrizacion-helm.md)

## Objetivo

Crear un **chart Helm** para empaquetar la demo **Flask + nginx** y sustituir los YAML sueltos de M03.

## Prerrequisitos

- M03 completado (namespace `cloudnative-lab` y manifests en kind).

> [!IMPORTANT]
> **No pongas `templates/namespace.yaml` en el chart.**
>
> El namespace `cloudnative-lab` **ya lo creaste en M03** con `kubectl`. Si el chart intenta crear el mismo Namespace, Helm falla con *invalid ownership metadata* / *cannot be imported into the current release*.
>
> El chart solo despliega recursos **dentro** del namespace del release (`helm install -n cloudnative-lab`).
>
> En los templates usa **`{{ .Release.Namespace }}`**, no `namespace:` en `values.yaml` ni `{{ .Values.namespace }}`. Así el `-n` del comando y los objetos en el clúster **siempre coinciden** (mismas anotaciones `meta.helm.sh/release-namespace`).

## Antes de empezar

```bash
./scripts/lab-prepare.sh m04-01
kubectl get namespace cloudnative-lab   # debe existir desde M03
```

Referencia: `infra/helm/solutions/cloudnative-demo/`.

## Mapa del ejercicio

```text
Paso 1   Estructura del chart (sin Namespace template)
Paso 2   Templates Deployment/Service API y Web
Paso 3   values.yaml con imágenes locales
Paso 4   helm install -n cloudnative-lab
```

---

### 1 — Crear el chart

```bash
mkdir -p infra/helm
helm create infra/helm/cloudnative-demo
```

Elimina templates de ejemplo (nginx, etc.) y **elimina también `templates/namespace.yaml`** si `helm create` lo generó. Conserva `Chart.yaml`, `values.yaml`, `templates/` (solo app).

---

### 2 — Plantillas mínimas

Traslada tus manifests M03 a templates Helm con `{{ .Values.api.image }}`, **`{{ .Release.Namespace }}`**, etc.

Archivos mínimos:

- `templates/api.yaml` (Deployment + Service + ConfigMap + Secret si agrupas)
- `templates/web.yaml`
- `templates/redis.yaml`, `postgres.yaml` (opcional flags `.Values.redis.enabled`)

**No incluyas** `templates/namespace.yaml`.

Ejemplo en cada recurso:

```yaml
metadata:
  name: demo-api
  namespace: {{ .Release.Namespace }}
```

---

### 3 — values.yaml

```yaml
api:
  image: cloudnative-demo-api:local
  replicas: 2
  servicePort: 8081
web:
  image: cloudnative-demo-web:local
  replicas: 1
  servicePort: 8080
  nodePort: 30080
```

**No pongas `namespace:` en values.** El namespace lo define `helm install -n cloudnative-lab`. Si mezclas `namespace: cloudnative-lab` en values con `-n cloudnative-lab2`, los objetos van a un sitio y el release a otro → choques de ownership al hacer otro install.

---

### 4 — Instalar

```bash
helm lint infra/helm/cloudnative-demo
helm upgrade --install cloudnative-demo infra/helm/cloudnative-demo \
  -n cloudnative-lab --create-namespace
kubectl -n cloudnative-lab get pods
./scripts/lab-verify.sh m04-01
```

`--create-namespace` crea el namespace **solo si no existe** (en M03 ya existe; no hace daño). Lo importante es **`-n cloudnative-lab`**: eso rellena `.Release.Namespace` en todos los templates.

> [!NOTE]
> Cada vez que edites **templates** o **values.yaml**, repite `helm upgrade --install` (o `./scripts/helm-install.sh`). Helm no sincroniza el clúster al guardar ficheros.

O con el script del curso:

```bash
./scripts/helm-install.sh cloudnative-demo cloudnative-lab
```

---

## Errores frecuentes

| Error | Causa | Arreglo |
|-------|-------|---------|
| `Namespace "cloudnative-lab" exists and cannot be imported` | Chart con `templates/namespace.yaml` | Borra ese template |
| `release-namespace` distinto al `-n` actual (p. ej. `postgres`, `cloudnative-lab2`) | Install previo con `-n` distinto o `namespace:` en values ≠ `-n` | `helm uninstall` del release viejo; usa `{{ .Release.Namespace }}`; reinstala con un solo `-n` |
| `release-name` debe equal `cnd3` / current value `cnd2` | Mismo chart/nombres de recurso, otro release, otro `-n` | Un release por entorno; nombres de recurso únicos o desinstalar el release anterior |
| `spec.ports[0].port: Invalid value: 0` | Falta `api.servicePort` / `web.servicePort` en values | Añade puertos (8081 / 8080) como en la solución |
| `helm list` vacío pero falla install | Recursos huérfanos de kubectl (M03) o Helm previo | Limpia recursos conflictivos o `helm uninstall` + delete secret/cm |

---

## Comprueba tu entendimiento

**¿Helm vs YAML plano?**

→ Chart versionado, valores por entorno, releases con historial (`helm history`).

**¿Dónde se define el namespace?**

→ En `helm install -n <ns>`. Los templates usan `{{ .Release.Namespace }}`. No dupliques `namespace:` en `values.yaml`.

**¿Para qué `--create-namespace`?**

→ Crea el namespace del `-n` si no existe. No sustituye a `.Release.Namespace` en templates.

→ **[M04-02 — Parametrización](M04-02-parametrizacion-helm.md)**
