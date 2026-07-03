# M03-02 — Estrategias de despliegue

[← Página anterior](M03-01-diseno-despliegue.md) · [Siguiente página →](M03-03-persistencia-postgresql.md)

## Objetivo

Practicar **rolling update**, detectar una versión mala y hacer **rollback** sobre el Deployment de la **API Flask**.

## Prerrequisitos

- M03-01 completado (manifiestos aplicados en `cloudnative-lab`).
- **PostgreSQL desplegado en el clúster** (ver bloque siguiente — obligatorio para este lab).

> [!IMPORTANT]
> **Lee esto antes de empezar — evita el error más frecuente del lab**
>
> En Kubernetes un Pod puede estar **`Running`** y aun así **`0/1 Ready`**.
>
> | Estado | Significado |
> |--------|-------------|
> | `Running` | El contenedor arrancó (proceso `python api.py` vivo). |
> | `Ready` | El **readinessProbe** recibió HTTP **200** en `GET /ready`. |
>
> Tu API Flask implementó `/ready` en M02-01 para comprobar **Postgres + Redis**. Si Postgres **no existe** en el clúster, `/ready` responde **503** → el Pod **nunca** pasa a Ready → `kubectl rollout status` **se queda esperando para siempre**.
>
> Eso **no es un fallo del terminal** ni del `rollout restart`. Es Kubernetes haciendo su trabajo: no da por bueno un despliegue cuyos Pods declaran que no están listos para recibir tráfico.
>
> **No confundas:** cambiar `SERVICE_NAME` en el ConfigMap **no rompe** `/ready`. Si el rollout se atasca, la causa casi siempre es readiness (Postgres ausente o Redis caído), no el cambio de variable.

## Antes de empezar

```bash
./scripts/lab-prepare.sh m03-02
kubectl apply -f infra/k8s/base/ -n cloudnative-lab
```

**PostgreSQL (obligatorio para que `/ready` responda 200):**

En M03-01 solo desplegaste Redis. Para M03-02 necesitas Postgres. Opciones:

```bash
# A) Copiar solución M03-03 y aplicar (recomendado)
./scripts/lab-solution.sh m03-03
kubectl apply -f infra/k8s/base/postgres.yaml -n cloudnative-lab

# B) O aplicar directamente la referencia
kubectl apply -f infra/k8s/solutions/m03-03/postgres-statefulset.yaml -n cloudnative-lab
```

**Comprueba que el despliegue está sano antes del rolling update:**

```bash
kubectl -n cloudnative-lab get pods -l app=demo-api
# Debe mostrar 2/2 READY (o al menos 1/1 en cada Pod: X/X READY en la columna READY)

kubectl -n cloudnative-lab port-forward svc/demo-api 8081:8081 &
curl -s http://127.0.0.1:8081/ready | jq .
# Debe devolver: "status": "ready"  (no "not_ready" ni HTTP 503)
```

Si ves `0/2 READY` en el Deployment, **no pases al paso 2** hasta resolver Postgres/Redis (sección [Errores frecuentes](#errores-frecuentes)).

## Mapa del ejercicio

```text
Paso 0   Confirmar 2/2 READY (Postgres + Redis OK)
Paso 1   Observar ReplicaSet actual
Paso 2   Rolling update (cambio de ConfigMap + restart)
Paso 3   Simular fallo (imagen rota)
Paso 4   Rollback con kubectl rollout
```

---

### 0 — Confirmar estado sano (no lo saltes)

```bash
kubectl -n cloudnative-lab get deploy demo-api
kubectl -n cloudnative-lab get pods -l app=demo-api
kubectl -n cloudnative-lab get svc postgres redis
```

**Resultado esperado:**

```text
NAME       READY   UP-TO-DATE   AVAILABLE
demo-api   2/2     2            2
```

Cada Pod: `1/1 Running` en READY (no `0/1`).

---

### 1 — Estado inicial

```bash
kubectl -n cloudnative-lab get deploy,rs,pods -l app=demo-api
kubectl -n cloudnative-lab describe deploy demo-api | grep -A5 "RollingUpdate"
```

**Por qué:** Kubernetes actualiza Pods de forma gradual (`RollingUpdate`) para no tumbar el servicio de golpe. Durante el update puedes ver **dos ReplicaSets** a la vez; es normal.

---

### 2 — Rolling update por variable

**Acción:** Cambia solo `SERVICE_NAME` en el ConfigMap (por ejemplo a `cloudnative-demo-api-v2`). **No toques** `REDIS_URL` ni `PORT`.

```bash
kubectl -n cloudnative-lab edit configmap demo-api-config
kubectl -n cloudnative-lab rollout restart deployment/demo-api
kubectl -n cloudnative-lab rollout status deployment/demo-api --timeout=120s
```

En otra terminal (mientras corre el rollout):

```bash
kubectl -n cloudnative-lab get pods -l app=demo-api -w
```

**Qué ocurre por dentro:**

1. `rollout restart` crea Pods nuevos con la config actualizada.
2. Kubernetes espera a que los Pods **nuevos** pasen el readinessProbe (`GET /ready`).
3. Solo entonces termina Pods viejos y el mensaje pasa a `successfully rolled out`.

**Verificar el cambio:**

```bash
kubectl -n cloudnative-lab port-forward svc/demo-api 8081:8081 &
curl -s http://127.0.0.1:8081/health | jq .
# "service" debe reflejar el nuevo SERVICE_NAME
```

**Resultado esperado:** `rollout status` termina en ~1–2 min; Deployment `2/2 READY`; nuevo ReplicaSet; Pods viejos en `Terminating`.

> [!NOTE]
> Si `rollout status` muestra `Waiting for deployment ... 1 out of 2 new replicas have been updated...` **más de 2 minutos**, pulsa `Ctrl+C` (solo cancelas la espera en tu terminal) y ve a [Rollout atascado](#rollout-atascado-readinessprobe-fallando).

---

### 3 — Simular despliegue fallido

**Acción:** Imagen con tag inexistente.

```bash
kubectl -n cloudnative-lab set image deployment/demo-api api=cloudnative-demo-api:broken
kubectl -n cloudnative-lab get pods -l app=demo-api
```

**Resultado esperado:** Pods nuevos en `ImagePullBackOff` o `ErrImagePull`; el rollout **no** completa. Los Pods viejos (si seguían Ready) pueden seguir sirviendo tráfico.

---

### 4 — Rollback

```bash
kubectl -n cloudnative-lab rollout undo deployment/demo-api
kubectl -n cloudnative-lab rollout status deployment/demo-api --timeout=120s
kubectl -n cloudnative-lab rollout history deployment/demo-api
```

**Por qué:** `rollout undo` vuelve al ReplicaSet anterior — patrón operativo en producción cuando un despliegue falla.

---

## Reto

Escala Postgres a 0 réplicas y observa cómo `/ready` pasa a 503 y el Deployment deja de tener Pods Ready. Vuelve a escalar a 1 y recupera el estado.

```bash
kubectl -n cloudnative-lab scale statefulset postgres --replicas=0
kubectl -n cloudnative-lab get pods -l app=demo-api -w
```

---

## Errores frecuentes

### Rollout atascado (`rollout status` no termina)

**Síntoma:**

```text
Waiting for deployment "demo-api" rollout to finish: 1 out of 2 new replicas have been updated...
```

Y `kubectl get pods` muestra `Running` pero **`0/1`** en READY.

**Causa:** El readinessProbe llama a `/ready`; Flask devuelve **503** porque Postgres o Redis no responden.

**Diagnóstico (copia y pega):**

```bash
kubectl -n cloudnative-lab describe pod -l app=demo-api | grep -A2 "Readiness"
kubectl -n cloudnative-lab get svc postgres redis
kubectl -n cloudnative-lab port-forward svc/demo-api 8081:8081 &
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8081/ready
curl -s http://127.0.0.1:8081/ready | jq .
```

| Lo que ves | Significado |
|------------|-------------|
| `Readiness probe failed ... statuscode: 503` | `/ready` falla — revisa Postgres/Redis |
| `get svc postgres` → NotFound | Falta desplegar Postgres (paso «Antes de empezar») |
| JSON con `"not_ready"` y error de conexión a `postgres` | Mismo caso: aplica `postgres.yaml` |
| HTTP 200 y `"status": "ready"` pero rollout atascado | Menos habitual; revisa `kubectl describe deploy demo-api` (eventos) |

**Arreglo:**

```bash
kubectl apply -f infra/k8s/solutions/m03-03/postgres-statefulset.yaml -n cloudnative-lab
kubectl -n cloudnative-lab rollout restart deployment/demo-api
kubectl -n cloudnative-lab rollout status deployment/demo-api --timeout=180s
```

`rollout undo` **no ayuda** si la revisión anterior tampoco tenía Pods Ready (misma falta de Postgres).

---

### Confundir `Running` con `Ready`

| Columna | Qué mirar |
|---------|-----------|
| `STATUS` = Running | Contenedor vivo |
| `READY` = 0/1 | **Readiness fallando** — el Service **no** envía tráfico a ese Pod |

---

### Dos ReplicaSets activos

Normal durante un rolling update. Si lleva >5 min y READY no sube, no es «lento»: es readiness fallando.

---

### Cambié el ConfigMap y «se rompió»

Cambiar `SERVICE_NAME` solo afecta al JSON de `/health` y `/ready`. Si el rollout falló tras el edit, casi seguro **ya tenías** `0/2 READY` antes del restart. Comprueba con `kubectl get deploy demo-api` el historial de AVAILABLE.

---

→ **[M03-03 — Persistencia PostgreSQL](M03-03-persistencia-postgresql.md)** (profundiza en Postgres; en M03-02 ya lo usaste de forma temporal)

```bash
./scripts/lab-verify.sh m03-02
```
