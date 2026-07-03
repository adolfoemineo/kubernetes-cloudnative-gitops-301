# M04-03 — Organización con Kustomize

[← Página anterior](M04-02-parametrizacion-helm.md) · [Siguiente página →](../M05-cicd/README.md)

## Objetivo

Organizar manifests con **Kustomize**: base + overlays `dev` y `staging` sin duplicar YAML.

## Prerrequisitos

- M04-02 completado.

## Antes de empezar

```bash
./scripts/lab-prepare.sh m04-03
```

Referencia: `infra/kustomize/solutions/`.

---

### 1 — Base

```bash
mkdir -p infra/kustomize/base infra/kustomize/overlays/{dev,staging}
```

`base/kustomization.yaml` referencia tus recursos K8s (o los de `infra/k8s/base/`).

---

### 2 — Overlay dev

`overlays/dev/kustomization.yaml`:

```yaml
resources:
  - ../../base
nameSuffix: -dev
patches:
  - patch: |-
      - op: replace
        path: /spec/replicas
        value: 1
    target:
      kind: Deployment
      name: demo-api
```

---

### 3 — Previsualizar y aplicar

```bash
kubectl kustomize infra/kustomize/overlays/dev
kubectl apply -k infra/kustomize/overlays/dev
```

---

### 4 — Comparar overlays

```bash
diff <(kubectl kustomize infra/kustomize/overlays/dev) \
     <(kubectl kustomize infra/kustomize/overlays/staging)
```

**Por qué:** Kustomize complementa Helm — patches declarativos por carpeta; ArgoCD soporta ambos.

---

→ **[M05 — CI/CD](../M05-cicd/README.md)**

```bash
./scripts/lab-verify.sh m04-03
```
