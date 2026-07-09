# M04 — Helm y Kustomize

[← Página anterior](../M03-kubernetes-desarrolladores/M03-03-persistencia-postgresql.md) · [Siguiente página →](M04-01-intro-helm.md)

## Qué aprenderás

- Crear e instalar charts Helm.
- Parametrizar despliegues con `values.yaml` y overrides.
- Organizar manifests con Kustomize (bases y overlays).

## Teoría

**Helm** empaqueta aplicaciones Kubernetes como charts versionados. Tras cambiar templates o values hay que ejecutar **`helm upgrade`** para que el clúster refleje el cambio (a diferencia de editar y olvidar). **Kustomize** patcha manifests sin templates, ideal para overlays por entorno.

## Ahora practica tú

| Lab | Título | Temario |
|-----|--------|---------|
| M04-01 | [Introducción a Helm](M04-01-intro-helm.md) | LAB 6 |
| M04-02 | [Parametrización con Helm](M04-02-parametrizacion-helm.md) | LAB 7 |
| M04-03 | [Organización con Kustomize](M04-03-kustomize.md) | LAB 8 |

→ Empieza por **[M04-01](M04-01-intro-helm.md)**.
