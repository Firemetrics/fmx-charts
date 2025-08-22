# Firemetrics Helm Charts

Helm charts for deploying the Firemetrics ecosystem.

## Prerequisites

The following cluster components are required for the Firemetrics ecosystem to function properly:

- [Argo CD](https://argo-cd.readthedocs.io/en/stable/)
- [Traefik ingress controller](https://doc.traefik.io/traefik/getting-started/quick-start-with-kubernetes/).
- [Postgres Operator](https://github.com/zalando/postgres-operator/blob/master/docs/quickstart.md#deployment-options)

Depending on the configuration, you may also need the following components:

- [Cert-Manager](https://cert-manager.io/docs/installation/)
- [MinIO-Operator](https://artifacthub.io/packages/helm/minio-operator/operator)

## Configuration

The `fmx-instance` chart is designed to be configured via Helm values. Take a look at the [values.yaml](charts/fmx-instance/values.yaml) file for the available configuration options.

## Installation

Create a secret for access to the `ghcr.io` registry:

```bash
kubectl -n my-namespace create secret docker-registry \
  --docker-server ghcr.io \
  --docker-username user \
  --docker-password token \
  docker-registry
```

Create generic secrets:

```bash
kubectl -n my-namespace create secret generic keycloak-admin \
  --from-literal username=user \
  --from-literal password="$(openssl rand -base64 24)"

kubectl -n my-namespace create secret generic keycloak-db-user \
  --from-literal username=keycloak \
  --from-literal password="$(openssl rand -base64 24)"

kubectl -n my-namespace create secret generic fuego-oidc-client \
  --from-literal id=fuego \
  --from-literal secret="$(openssl rand -base64 24)"
```

Then create an Argo CD application for the `fmx-instance` chart:

```bash
argocd app create fmx \
  --repo https://nexus.firemetricshealth.com/repository/helm-firemetrics/ \
  --helm-chart fmx-instance \
  --revision 'x.x.x' \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace my-namespace \
  --parameter imagePullSecret=docker-registry \
  --sync-policy automated \
  --auto-prune \
  --self-heal
```
