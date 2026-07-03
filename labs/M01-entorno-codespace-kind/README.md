# M01 — Entorno Codespace, kind y aplicación demo

[← Página anterior](../../README.md) · [Siguiente página →](M01-01-bootstrap-entorno.md)

> [!NOTE]
> **Cómo funciona este módulo.** Lee la **teoría** y la tabla de **scripts** en este README; después practicas en los laboratorios M01-01 y M01-02.

## Qué aprenderás

- Preparar tu fork y Codespace con Docker, kind, kubectl, Helm y Kustomize.
- Entender **para qué sirve cada script** del repositorio y cuándo usarlo.
- Crear el clúster Kubernetes local donde correrán todos los labs.
- Verificar conectividad y herramientas antes de adaptar la aplicación demo.

## Teoría

Este curso usa **GitHub Codespaces** como entorno homogéneo: no instalas Docker ni Kubernetes en tu equipo. Dentro del Codespace, **kind** (Kubernetes IN Docker) levanta un clúster de un nodo que simula un entorno cloud.

| Componente | Rol en el curso |
|------------|-----------------|
| **Codespace** | IDE + Docker + herramientas CLI |
| **kind** | Clúster Kubernetes local (M01–M08) |
| **kubectl / Helm / Kustomize** | Operación y empaquetado |
| **App demo** | Caso práctico que evoluciona módulo a módulo |

> [!IMPORTANT]
> El módulo **M07 (Azure AKS)** es contenido de **referencia comparativa**. No necesitas suscripción Azure; tu práctica principal es sobre **kind**.

## Scripts del entorno (`scripts/`)

Los laboratorios usan scripts para **automatizar tareas repetitivas**, reducir errores de copy-paste y garantizar que todos los alumnos ejecutan los mismos pasos. No sustituyen entender qué hacen: si fallan, sabrás qué comprobar.

| Script | Qué hace | Por qué lo usamos | Cuándo ejecutarlo |
|--------|----------|-------------------|-------------------|
| **`bootstrap-tools.sh`** | Instala **kind** y **kustomize** si no están en el PATH | El devcontainer trae Docker, kubectl y Helm; kind/kustomize se añaden al crear el Codespace | Automático en `postCreate`; manual si falta alguna herramienta |
| **`kind-up.sh`** | Crea el clúster **`cloudnative-lab`** con `infra/kind/cluster-config.yaml` (si no existe) | Evita escribir `kind create cluster` a mano y asegura la config del curso (ingress, puertos) | Inicio de M01 y antes de labs Kubernetes (M03+) |
| **`kind-down.sh`** | Elimina el clúster `cloudnative-lab` | Libera RAM y deja un estado limpio para recrear desde cero | Troubleshooting o reset del entorno K8s |
| **`lab-up.sh`** | Copia `.env.example` → `.env` si falta; `docker compose up -d --build`; llama a `health-check.sh` | Un solo comando levanta la stack demo (web, API, Postgres, Redis, loadgen) | M01-02 y módulos Docker (M02) |
| **`lab-down.sh`** | `docker compose down` — para y elimina contenedores de la stack demo | Apagar el lab sin borrar imágenes; útil antes de rebuild limpio | Cuando quieras liberar recursos o reiniciar Compose |
| **`health-check.sh`** | Comprueba Docker, clúster kind, kubectl/helm/kustomize y endpoints 8080/8081 | Diagnóstico rápido: «¿está todo listo?» con mensajes OK/AVISO | Tras `kind-up` o `lab-up`; cuando algo no responde |
| **`image-size-compare.sh`** | Construye imagen legacy vs multistage y muestra tabla de tamaños | Comparación reproducible en M02-02 sin memorizar comandos `docker build` | M02-02 |
| **`lab-prepare.sh`** | Restaura punto de partida (`m02-01` … `m08-03`) | Evita repetir labs con estado «ya hecho» | Antes de cada lab M02+ |
| **`lab-verify.sh`** | Comprueba lab completado (`m02-01` … `m08-03`) | Autocorrección sin mirar la solución | Al final de cada lab |
| **`lab-solution.sh`** | Copia solución (formador / recuperación) | Recuperar tras bloqueo | Solo formador o emergencia |

**Flujo habitual al empezar el curso:**

```text
Codespace creado  →  bootstrap-tools.sh (automático)
                 →  kind-up.sh
                 →  lab-up.sh
                 →  health-check.sh (incluido en lab-up)
```

> [!TIP]
> Todos los scripts asumen que los ejecutas desde la **raíz del repositorio** (`./scripts/nombre.sh`). Usan rutas relativas a `infra/` y no dependen de tu directorio actual gracias a `ROOT="$(cd ...)"`.

## Ahora practica tú

| Lab | Título | Qué harás |
|-----|--------|-----------|
| M01-01 | [Bootstrap del entorno](M01-01-bootstrap-entorno.md) | Fork, Codespace, kind, scripts de verificación |
| M01-02 | [Verificar aplicación demo](M01-02-aplicacion-demo.md) | Stack Compose, scripts `lab-up` / `lab-down`, explorar la app |

→ Empieza por **[M01-01 — Bootstrap del entorno](M01-01-bootstrap-entorno.md)**.
