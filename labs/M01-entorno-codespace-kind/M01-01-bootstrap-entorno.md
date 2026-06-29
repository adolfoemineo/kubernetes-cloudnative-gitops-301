# M01-01 — Bootstrap del entorno

[← Página anterior](README.md) · [Siguiente página →](M01-02-aplicacion-demo.md)

> Práctica del módulo. La teoría y la demo están en el [README del módulo](README.md).

### Objetivo

Dejar operativo tu fork, Codespace, clúster **kind** y herramientas del curso.

### Prerrequisitos

- Cuenta GitHub personal.
- Navegador actualizado y acceso a GitHub Codespaces.

### En qué consiste

Fork del repositorio, arranque del Codespace, instalación de herramientas (automática), creación del clúster Kubernetes local y validación con `health-check.sh`.

### 1 — Fork y Codespace

**Acción:** Haz fork de `my-it-labs/kubernetes-cloudnative-gitops-301` en tu cuenta GitHub. Desde tu fork, abre **Code → Codespaces → Create codespace on main**.

**Por qué:** Cada alumno trabaja en su copia y conserva el material al finalizar el curso.

**Resultado esperado:** Terminal en `/workspaces/kubernetes-cloudnative-gitops-301` (o el nombre de tu fork).

### 2 — Esperar el postCreate

**Acción:** Tras crear el Codespace, espera a que termine el comando `postCreate` del devcontainer (instala kind, kustomize y permisos en scripts).

**Por qué:** Sin kind y kubectl no podrás crear el clúster local de los laboratorios.

**Resultado esperado:** `docker info` responde sin error y `command -v helm` devuelve una ruta.

### 3 — Crear el clúster kind

**Acción:** Desde la raíz del repo ejecuta:

```bash
./scripts/kind-up.sh
```

**Por qué:** Todas las prácticas de Kubernetes, Helm, GitOps y observabilidad corren sobre este clúster local (`cloudnative-lab`).

**Resultado esperado:**

```text
kubectl get nodes
NAME                         STATUS   ROLES           AGE   VERSION
cloudnative-lab-control-plane   Ready    control-plane   ...   v1.x
```

### 4 — Comprobar herramientas

**Acción:** Ejecuta `./scripts/health-check.sh`.

**Por qué:** Confirma Docker, kind, kubectl, Helm y Kustomize antes de seguir.

**Resultado esperado:** Líneas `OK:` para Docker, clúster kind y herramientas. El stack Compose puede aparecer como AVISO hasta M01-02.

### 5 — Contexto kubectl

**Acción:** Ejecuta `kubectl config current-context`.

**Por qué:** Debes operar siempre sobre el clúster del curso, no sobre otro contexto residual.

**Resultado esperado:** `kind-cloudnative-lab`.

## Comprueba tu entendimiento

**Clúster listo**
Ejecuta `kubectl get nodes -o wide` y verifica un nodo en estado `Ready`.
→ Un único nodo `control-plane` del clúster `cloudnative-lab`.

**Herramientas**
Ejecuta `helm version --short && kustomize version`.
→ Versiones impresas sin error.

## Reto

### 1 — Identifica tu entorno

Anota (para ti) el nombre del clúster kind y cuánta memoria RAM tiene tu Codespace (`grep MemTotal /proc/meminfo`).

<details>
<summary>Ver orientación</summary>

El clúster se llama `cloudnative-lab`. Para observabilidad en M08 conviene ≥ 8 GB RAM.

</details>

## Errores frecuentes

| Síntoma | Causa probable | Cómo arreglarlo |
|---------|----------------|-----------------|
| `kind: command not found` | postCreate no terminó | Ejecuta `bash scripts/bootstrap-tools.sh` |
| Nodo `NotReady` | Docker sin recursos | Reinicia el Codespace con máquina de 8 GB |
| Contexto kubectl incorrecto | Otro cluster por defecto | `kubectl config use-context kind-cloudnative-lab` |
| `kind create cluster` timeout | Imágenes K8s lentas | Repite `./scripts/kind-down.sh && ./scripts/kind-up.sh` |
