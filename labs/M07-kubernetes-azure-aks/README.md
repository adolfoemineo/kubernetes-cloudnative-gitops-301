# M07 — Kubernetes en Azure (AKS) — demo

[← Página anterior](../M06-gitops-argocd/M06-03-promocion-entornos.md) · [Siguiente página →](M07-01-despliegue-aks.md)

> [!IMPORTANT]
> Este módulo es una **demostración del instructor**. **No necesitas suscripción Azure** ni ejecutar estos pasos en tu Codespace.

## Qué aprenderás

- Diferencias entre un clúster **kind** local y **AKS** gestionado en Azure.
- Consideraciones de despliegue en cloud: identidad, networking, registries, add-ons.

## Teoría

| Aspecto | kind (lab) | AKS (cloud) |
|---------|------------|-------------|
| Provisión | Script local | Servicio gestionado Azure |
| Control plane | Contenedor Docker | Microsoft operado |
| Persistencia | Local al Codespace | Discos Azure, CSI |
| Ingress/LB | NodePort / kind mapping | Azure Load Balancer |
| Coste | Incluido en Codespace | Suscripción Azure |

## Demostración guiada (formador)

1. Creación o uso de un clúster AKS de demostración.
2. Despliegue del mismo chart Helm usado en el curso.
3. Validación y comparación con el entorno kind del alumno.

## Material de referencia

| Lab | Título | Rol |
|-----|--------|-----|
| M07-01 | [Despliegue en AKS](M07-01-despliegue-aks.md) | Guion del formador / notas de la demo |

→ El formador ejecuta **[M07-01](M07-01-despliegue-aks.md)** en vivo; tú sigues y comparas con tu kind.

## Siguiente módulo

Continúa con **[M08 — Observabilidad](../M08-observabilidad/README.md)**.
