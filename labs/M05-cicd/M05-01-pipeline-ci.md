# M05-01 — Pipeline de integración continua

[← Página anterior](README.md) · [Siguiente página →](M05-02-pipeline-cd.md)

## Objetivo

Automatizar **build** de imágenes Docker (Spring Boot + Angular) y **push** a GHCR con GitHub Actions.

## Prerrequisitos

- M04 completado.
- Fork en tu cuenta GitHub (para ejecutar Actions).

Referencia: `.github/workflows/solutions/ci.yml`.

## Antes de empezar

```bash
./scripts/lab-prepare.sh m05-01
```

El repo **no** incluye el workflow activo — lo crearás en `.github/workflows/ci.yml` (referencia: `.github/workflows/solutions/ci.yml`).

---

### 1 — Estructura del workflow

Dispara en `push` a `main` cuando cambie `infra/app/**`:

| Job | Qué hace |
|-----|----------|
| checkout | Código del fork |
| login GHCR | `GITHUB_TOKEN` + `docker/login-action` |
| build API | `docker/build-push-action` context `infra/app/api` |
| build Web | context `infra/app/web` |

Tags sugeridos: `ghcr.io/<tu-usuario>/<repo>/demo-api:${{ github.sha }}`.

---

### 2 — Crear el fichero

Copia la referencia y adapta `REGISTRY` / nombres de imagen a tu fork.

```bash
mkdir -p .github/workflows
cp .github/workflows/solutions/ci.yml .github/workflows/ci.yml
# edita owner/repo en tags
```

---

### 3 — Ejecutar

```bash
git add .github/workflows/ci.yml
git commit -m "Add CI pipeline for Spring Boot and Angular images"
git push
```

En GitHub → **Actions** → comprueba build verde y paquetes en **Packages**.

---

### 4 — Validar imagen

Descarga o inspecciona el digest publicado; en el lab local sigues usando `:local` en kind.

---

→ **[M05-02 — Pipeline CD](M05-02-pipeline-cd.md)**

```bash
./scripts/lab-verify.sh m05-01
```
