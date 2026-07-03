# M06-01 — Introducción a GitOps

[← Página anterior](README.md) · [Siguiente página →](M06-02-sincronizacion-automatica.md)

## Objetivo

Instalar **ArgoCD** en kind y desplegar la demo desde un `Application` que apunta a tu overlay Kustomize.

## Prerrequisitos

- M05 completado.
- Overlay Kustomize en `infra/kustomize/overlays/dev`.

## Antes de empezar

```bash
./scripts/lab-prepare.sh m06-01
```

---

### 1 — Instalar ArgoCD

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl -n argocd wait --for=condition=available deployment/argocd-server --timeout=300s
```

---

### 2 — Acceso UI

```bash
kubectl -n argocd port-forward svc/argocd-server 8082:443 &
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d; echo
```

Usuario: `admin`.

---

### 3 — Application manifest

Copia `infra/argocd/solutions/application-dev.yaml` a `infra/argocd/application-dev.yaml` y ajusta `repoURL` a **tu fork**.

```bash
kubectl apply -f infra/argocd/application-dev.yaml
argocd app sync cloudnative-demo-dev   # CLI opcional
```

---

### 4 — Verificar reconciliación

Cambia réplicas en Git → push → observa sync en UI ArgoCD.

---

→ **[M06-02 — Sincronización automática](M06-02-sincronizacion-automatica.md)**

```bash
./scripts/lab-verify.sh m06-01
```
