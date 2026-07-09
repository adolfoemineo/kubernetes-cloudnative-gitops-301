# M08-02 — Logging centralizado

[← Página anterior](M08-01-prometheus-grafana.md) · [Siguiente página →](M08-03-diagnostico-incidencias.md)

## Objetivo

Centralizar logs de Pods Spring Boot y Angular con un stack **ligero** (Elasticsearch + Kibana o alternativa compatible con el RAM del Codespace).

## Prerrequisitos

- M08-01 completado.

## Antes de empezar

```bash
./scripts/lab-prepare.sh m08-02
```

Implementa manifests en `infra/observability/active/` (referencia: `infra/observability/solutions/elasticsearch-kibana.yaml`).

---

### 1 — Logs en Spring Boot

Spring Boot escribe a **stdout** por defecto (factor XI 12-factor). Comprueba:

```bash
kubectl -n cloudnative-lab logs deployment/demo-api --tail=20
```

---

### 2 — Desplegar Elasticsearch single-node (lab)

> [!WARNING]
> ELK completo consume mucha RAM. En Codespace usa **una réplica**, `ES_JAVA_OPTS=-Xms512m -Xmx512m`, o el perfil `observability-lite` de la solución del repo.

Manifest de referencia: documenta en `infra/observability/solutions/` el patrón DaemonSet/Fluent Bit → Elasticsearch.

---

### 3 — Kibana

Port-forward Kibana, filtra por `kubernetes.pod_name` o `app=demo-api`.

---

### 4 — Correlación

Abre un incidente en M08-03 y localiza la misma ventana temporal en logs y métricas.

---

→ **[M08-03 — Diagnóstico](M08-03-diagnostico-incidencias.md)**

```bash
./scripts/lab-verify.sh m08-02
```
