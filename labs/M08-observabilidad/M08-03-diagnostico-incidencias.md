# M08-03 — Diagnóstico de incidencias

[← Página anterior](M08-02-logging-elk.md) · [Siguiente página →](../../README.md)

## Objetivo

Diagnosticar fallos **inducidos** en la API Flask correlacionando métricas, logs y estado Kubernetes.

## Antes de empezar

```bash
./scripts/lab-prepare.sh m08-03
./scripts/obs-up.sh
```

---

### Escenario A — Postgres caído

```bash
kubectl -n cloudnative-lab scale statefulset postgres --replicas=0
curl -s http://127.0.0.1:8081/ready | jq .
kubectl -n cloudnative-lab get endpoints demo-api
```

**Qué documentar:** readiness 503, Pods Not Ready, logs JDBC en demo-api.

---

### Escenario B — Latencia (`/slow`)

```bash
curl "http://127.0.0.1:8081/slow"
```

En Grafana: latencia p95 de `http_server_requests`.

---

### Escenario C — Error 500 (`/fail`)

```bash
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8081/fail
```

Busca en logs el stack trace o respuesta simulada.

---

### Escenario D — Pod OOM

Reduce `memory.limits` del Deployment API, genera carga con `/work` en bucle, observa `kubectl describe pod`.

---

## Entregable del lab

Tabla breve:

| Síntoma | Métrica | Log | Acción |
|---------|---------|-----|--------|
| ... | ... | ... | ... |

---

→ **[Índice del curso](../../README.md)**

```bash
./scripts/lab-verify.sh m08-03
```
