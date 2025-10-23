# Firemetrics Helm Charts

Helm charts for deploying the Firemetrics ecosystem using Argo CD's App of Apps pattern.

## Architecture

This repository implements the [App of Apps pattern](https://argo-cd.readthedocs.io/en/latest/operator-manual/cluster-bootstrapping/#app-of-apps-pattern) for GitOps deployment of the complete Firemetrics healthcare metrics platform. The `fmx-instance` chart serves as the umbrella application, with each component (PostgreSQL, Keycloak, Panel, Fuego, Grafana, etc.) deployed as a separate Argo CD Application. A single `values.yaml` file configures the entire ecosystem, with proper orchestration ensuring services start in the correct order.

## Prerequisites

The following cluster components are required for the Firemetrics ecosystem to function properly:

- [Argo CD](https://argo-cd.readthedocs.io/en/stable/)
- [Traefik ingress controller](https://doc.traefik.io/traefik/getting-started/quick-start-with-kubernetes/).
- [Postgres Operator](https://github.com/zalando/postgres-operator/blob/master/docs/quickstart.md#deployment-options)

Depending on the configuration, you may also need the following components:

- [Cert-Manager](https://cert-manager.io/docs/installation/)
- [MinIO-Operator](https://artifacthub.io/packages/helm/minio-operator/operator)

## Configuration

The `fmx-instance` chart implements the App of Apps pattern and is designed to be configured via Helm values. The parent application uses a single [values.yaml](charts/fmx-instance/values.yaml) file to configure all child applications in the ecosystem.

Key configuration areas include:

- **hostname**: Domain for the Firemetrics instance
- **components**: Enable/disable individual services (postgres, keycloak, fuego, panel, grafana, etc.)
- **oidc**: OIDC authentication settings propagated to all services
- **tls**: TLS/SSL certificate configuration
- **database**: PostgreSQL cluster configuration

## Secrets

The following secrets are required for the `fmx-instance` chart to function properly. Replace the values with your own secure credentials:

```bash
kubectl -n fmx create secret generic keycloak-admin \
  --from-literal username=admin \
  --from-literal password="$(openssl rand -base64 24)"

kubectl -n fmx create secret generic keycloak-db-user \
  --from-literal username=keycloak \
  --from-literal password="$(openssl rand -base64 24)"

kubectl -n fmx create secret generic fuego-oidc-client \
  --from-literal id=fuego \
  --from-literal secret="$(openssl rand -base64 24)"

kubectl -n fmx create secret generic hapi-oidc-client \
  --from-literal id=hapi \
  --from-literal secret="$(openssl rand -base64 24)"

kubectl -n fmx create secret generic panel-db-user \
  --from-literal username=panel \
  --from-literal password="$(openssl rand -base64 24)"

kubectl -n fmx create secret generic panel-oidc-client \
  --from-literal id=panel \
  --from-literal secret="$(openssl rand -base64 24)"

kubectl -n fmx create secret generic grafana-db-user \
  --from-literal username=grafana \
  --from-literal password="$(openssl rand -base64 24)"

kubectl -n fmx create secret generic grafana-oidc-client \
  --from-literal id=grafana \
  --from-literal secret="$(openssl rand -base64 24)"

kubectl -n fmx create secret generic dicom-receiver-db-user \
  --from-literal username=dicom_receiver \
  --from-literal password="$(openssl rand -base64 24)"
```

For the configuration of MinIO, you will need two secrets: one for the services and one for the MinIO configuration.

```bash
MINIO_ROOT_PASSWORD="$(openssl rand -base64 24)"

kubectl -n fmx create secret generic minio-user \
  --from-literal accessKey=minio \
  --from-literal secretKey="$MINIO_ROOT_PASSWORD"

kubectl -n fmx apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: minio-config
type: Opaque
stringData:
  config.env: |-
    export MINIO_ROOT_USER=minio
    export MINIO_ROOT_PASSWORD=$MINIO_ROOT_PASSWORD
EOF
```

You will also need to create a secret for pulling images from the private Firemetrics container registry, unless you have a registry mirror configured.

```bash
kubectl -n fmx create secret docker-registry \
  --docker-server ghcr.io \
  --docker-username user \
  --docker-password token \
  docker-registry
```

## Installation

After creating the secrets, create an Argo CD application for the `fmx-instance` chart. This parent application will automatically create and manage all child applications for the individual services:

```bash
argocd app create fmx \
  --repo https://nexus.firemetricshealth.com/repository/helm-firemetrics/ \
  --helm-chart fmx-instance \
  --revision 'x.x.x' \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace fmx \
  --parameter imagePullSecret=docker-registry \
  --sync-policy automated \
  --auto-prune \
  --self-heal
```

Take a look at the configuration of the `fmx-instance` chart in the [values.yaml](https://github.com/Firemetrics/fmx-charts/blob/main/charts/fmx-instance/values.yaml) file for more details.

Once deployed, this single parent application will create individual Argo CD Applications for:

- PostgreSQL database cluster
- Keycloak authentication service
- Panel web interface
- Fuego API service
- Grafana monitoring
- Bootstrap database initialization
- Ingress configuration
- MinIO object storage
- DICOM receiver

Each child application can be monitored and managed independently through the Argo CD UI while maintaining centralized configuration through the parent application.
