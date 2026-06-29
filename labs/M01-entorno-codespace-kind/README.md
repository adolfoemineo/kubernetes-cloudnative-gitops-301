# M01 — Entorno Codespace, kind y aplicación demo

[← Página anterior](../../README.md) · [Siguiente página →](M01-01-bootstrap-entorno.md)

> [!NOTE]
> **Cómo funciona este módulo.** Primero la **teoría**, luego la **demostración guiada** del
> formador, y después **practicas tú** en el/los laboratorio(s).

## Qué aprenderás

- Preparar tu fork y Codespace con Docker, kind, kubectl, Helm y Kustomize.
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
> El bloque **Azure (AKS)** en M07 es **demostración del instructor**. Tu práctica es 100 % sobre kind.

## Demostración guiada

> Recorrido del formador (tono descriptivo).

1. En GitHub, el repositorio del curso se abre en Codespaces desde el fork del alumno.
2. Tras el postCreate del devcontainer, el terminal muestra Docker operativo y las herramientas instaladas.
3. Tras `./scripts/kind-up.sh`, `kubectl get nodes` devuelve un nodo `Ready`.
4. Tras `./scripts/lab-up.sh`, la API responde en 8081 y la web en 8080.

## Ahora practica tú

| Lab | Título | Qué harás |
|-----|--------|-----------|
| M01-01 | [Bootstrap del entorno](M01-01-bootstrap-entorno.md) | Fork, Codespace, kind, health-check |
| M01-02 | [Verificar aplicación demo](M01-02-aplicacion-demo.md) | Explorar `infra/app/` y primer contacto |

→ Empieza por **[M01-01 — Bootstrap del entorno](M01-01-bootstrap-entorno.md)**.
