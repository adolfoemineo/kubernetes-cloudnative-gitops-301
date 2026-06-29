# Problemas frecuentes

## Codespace no arranca o va lento

- Usa un Codespace con **al menos 8 GB RAM** (observabilidad + kind).
- Cierra procesos innecesarios; en M08 el stack ELK consume mucha memoria.

## `kind create cluster` falla

```bash
docker info
./scripts/kind-down.sh
./scripts/kind-up.sh
```

## kubectl: contexto incorrecto

```bash
kubectl config use-context kind-cloudnative-lab
kubectl get nodes
```

## No puedo hacer push a GHCR (M05)

- Comprueba permisos del workflow en tu fork (`Settings → Actions → General`).
- El `GITHUB_TOKEN` del workflow necesita permiso `packages: write`.

## Firewall corporativo

Debe permitir: `github.com`, `*.githubusercontent.com`, `ghcr.io`, `hub.docker.com`, repos públicos del curso.

## AKS (M07)

Los alumnos **no despliegan en Azure**. Si tienes dudas sobre credenciales cloud, ignora este bloque; es demo del instructor.
