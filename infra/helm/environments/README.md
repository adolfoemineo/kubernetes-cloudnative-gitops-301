# Values por entorno (fuera del chart)

Los overrides **no van dentro** de `cloudnative-demo/` (el chart es empaquetable y reutilizable).

Crea aquí, por ejemplo:

- `values-dev.yaml`
- `values-staging.yaml`

Uso:

```bash
helm upgrade --install cloudnative-demo infra/helm/cloudnative-demo \
  -n cloudnative-lab \
  -f infra/helm/environments/values-dev.yaml
```

Vuelve a ejecutar el mismo comando tras **cualquier** cambio en templates, `values.yaml` o estos overrides.

Referencia: `infra/helm/solutions/environments/`.
