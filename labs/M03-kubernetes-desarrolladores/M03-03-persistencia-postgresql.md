# M03-03 — Persistencia y PostgreSQL

[← Página anterior](M03-02-estrategias-despliegue.md) · [Siguiente página →](../M04-helm-kustomize/README.md)

## Objetivo

Desplegar **PostgreSQL** con StatefulSet + PVC y conectar la API Spring Boot (`spring.datasource`).

## Prerrequisitos

- M03-01 y M03-02 completados.

## Antes de empezar

```bash
./scripts/lab-prepare.sh m03-03
```

Referencia solución: `infra/k8s/solutions/m03-03/postgres-statefulset.yaml`.

## Mapa del ejercicio

```text
Paso 1   Secret postgres-secret
Paso 2   StatefulSet + headless Service
Paso 3   PVC y comprobación de datos
Paso 4   Validar /work y readiness con DB real
```

---

### 1 — Secret de Postgres

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: postgres-secret
type: Opaque
stringData:
  password: lab
```

---

### 2 — StatefulSet

Copia y adapta `postgres-statefulset.yaml` a `infra/k8s/base/postgres.yaml`:

- `serviceName: postgres`
- `volumeClaimTemplates` con `1Gi`
- Service headless (`clusterIP: None`)

```bash
kubectl apply -f infra/k8s/base/postgres.yaml -n cloudnative-lab
kubectl -n cloudnative-lab get pvc,pods -l app=postgres
```

---

### 3 — Persistencia

```bash
kubectl -n cloudnative-lab exec -it postgres-0 -- psql -U lab -d lab -c "SELECT 1;"
kubectl -n cloudnative-lab delete pod postgres-0
kubectl -n cloudnative-lab wait --for=condition=ready pod -l app=postgres --timeout=120s
kubectl -n cloudnative-lab exec -it postgres-0 -- psql -U lab -d lab -c "SELECT 1;"
```

**Por qué:** El PVC sobrevive al Pod — estado fuera del contenedor efímero (factor VI 12-factor).

---

### 4 — API + readiness

```bash
kubectl -n cloudnative-lab rollout restart deployment/demo-api
kubectl -n cloudnative-lab port-forward svc/demo-api 8081:8081 &
curl -s http://127.0.0.1:8081/actuator/health/readiness | jq .
curl -s http://127.0.0.1:8081/work | jq .
```

**Resultado esperado:** `readiness` UP; `/work` incrementa `hits` en Redis y consulta Postgres.

---

## Comprueba tu entendimiento

**¿Deployment o StatefulSet para Postgres?**

→ StatefulSet: identidad estable, PVC por réplica, headless DNS.

→ **[M04 — Helm y Kustomize](../M04-helm-kustomize/README.md)**

```bash
./scripts/lab-verify.sh m03-03
```
