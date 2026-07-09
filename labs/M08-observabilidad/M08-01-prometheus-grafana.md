# M08-01 — Prometheus y Grafana

[← Página anterior](README.md) · [Siguiente página →](M08-02-logging-elk.md)

## Objetivo

Monitorizar la **API Spring Boot** (Micrometer/Prometheus) con Prometheus y dashboards Grafana en kind.

## Prerrequisitos

- App desplegada con endpoint `/actuator/prometheus` (solución M02-01).
- M06 completado o stack demo en `cloudnative-lab`.

## Antes de empezar

```bash
./scripts/lab-prepare.sh m08-01
```

---

### 1 — Desplegar stack

Implementa manifests en `infra/observability/` basándote en `infra/observability/solutions/`, o para validar:

```bash
./scripts/obs-up.sh
```

---

### 2 — Comprobar scrape

```bash
kubectl -n cloudnative-lab port-forward svc/demo-api 8081:8081 &
curl -s http://127.0.0.1:8081/actuator/prometheus | head -20
```

Prometheus UI (NodePort 30090 o port-forward):

```bash
kubectl -n observability port-forward svc/prometheus 9090:9090
```

Busca métricas `jvm_`, `http_server_requests_*`.

---

### 3 — Grafana

```bash
kubectl -n observability port-forward svc/grafana 3000:3000
```

Login `admin` / `lab`. Añade datasource Prometheus `http://prometheus:9090`.

---

### 4 — Dashboard

Importa un dashboard JVM (ID comunitario) o crea panel con `rate(http_server_requests_seconds_count[5m])`.

---

→ **[M08-02 — Logging](M08-02-logging-elk.md)**

```bash
./scripts/lab-verify.sh m08-01
```
