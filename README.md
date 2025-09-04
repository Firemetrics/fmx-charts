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

The following secrets are required for the `fmx-instance` chart to function properly. Replace the values with your own secure credentials:

```bash
kubectl -n my-namespace create secret generic keycloak-admin \
  --from-literal username=admin \
  --from-literal password="$(openssl rand -base64 24)"

kubectl -n my-namespace create secret generic keycloak-db-user \
  --from-literal username=keycloak \
  --from-literal password="$(openssl rand -base64 24)"

kubectl -n my-namespace create secret generic fuego-oidc-client \
  --from-literal id=fuego \
  --from-literal secret="$(openssl rand -base64 24)"

kubectl -n my-namespace create secret generic panel-db-user \
  --from-literal username=panel \
  --from-literal password="$(openssl rand -base64 24)"

kubectl -n my-namespace create secret generic panel-oidc-client \
  --from-literal id=panel \
  --from-literal secret="$(openssl rand -base64 24)"

kubectl -n my-namespace create secret generic grafana-db-user \
  --from-literal username=grafana \
  --from-literal password="$(openssl rand -base64 24)"

kubectl -n my-namespace create secret generic grafana-oidc-client \
  --from-literal id=grafana \
  --from-literal secret="$(openssl rand -base64 24)"
```

You will also need to create a secret for pulling images from the private Firemetrics container registry, unless you have a registry mirror configured.

```bash
kubectl -n my-namespace create secret docker-registry \
  --docker-server ghcr.io \
  --docker-username user \
  --docker-password token \
  docker-registry
```

In case you have backups enabled, you will also need to create a secret for accessing the bucket.

```bash
kubectl -n my-namespace create secret generic backup-bucket-user \
  --from-literal accessKey=user \
  --from-literal secretKey="$(openssl rand -base64 24)"
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
