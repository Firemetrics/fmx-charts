# Firemetrics Helm Charts

Helm charts for deploying the Firemetrics ecosystem.

## Prerequisites

### Ingress

If you want to provision the ingress, you need to have the following components installed in your Kubernetes cluster:

- [Cert-Manager](https://cert-manager.io/docs/installation/)
- [Traefik ingress controller](https://doc.traefik.io/traefik/getting-started/quick-start-with-kubernetes/).

### Database

If you want to provision the PostgreSQL database, you need to have the [Postgres Operator](https://github.com/zalando/postgres-operator/blob/master/docs/quickstart.md#deployment-options) installed in your Kubernetes cluster.

## Deployment

### PostgreSQL Cluster

To deploy a Firemetrics PostgreSQL cluster, you can use the following command. Make sure to replace `<username>` and `<password>` with your actual values.

```bash
helm install --namespace fmx --create-namespace \
  --set 'registryAuth.enabled=true' \
  --set 'registryAuth.username=<username>' \
  --set 'registryAuth.password=<password>' \
  db ./charts/fmx-db
```

Wait until the PostgreSQL cluster's status switches to `Running` before proceeding with the next steps. You can check the status of the PostgreSQL cluster using the following command:

```bash
kubectl get -A postgresqls.acid.zalan.do
```

### Apps

To deploy the Firemetrics applications, you can use the following command. Make sure to replace `<username>`, `<password>`, `<admin-password>`, and `<host>` with your actual values.

```bash
helm install --namespace fmx --create-namespace --dependency-update \
  --set 'registryAuth.enabled=true' \
  --set 'registryAuth.username=<username>' \
  --set 'registryAuth.password=<password>' \
  --set 'keycloak.auth.adminPassword=<admin-password>' \
  --set 'ingress.enabled=true' \
  --set 'ingress.host=<host>' \
  --set 'database.existingUserSecret=firemetrics.pg.credentials.postgresql.acid.zalan.do' \
  apps ./charts/fmx-apps
```

## Installation

To install the Firemetrics chart, you can use the following command. Make sure to replace `<username>`, `<password>`, `<admin-password>`, and `<host>` with your actual values.

```bash
helm install --namespace fmx --create-namespace --dependency-update \
  --set 'registryAuth.enabled=true' \
  --set 'registryAuth.username=<username>' \
  --set 'registryAuth.password=<password>' \
  --set 'keycloak.auth.adminPassword=<admin-password>' \
  --set 'ingress.enabled=true' \
  --set 'ingress.host=<host>' \
  fmx .
```

## Configuration

You can customize the `fmx-apps` chart by modifying the `values.yaml` file or by passing additional parameters to the `helm install` command. By default, the chart is configured to deploy the following components:

- Keycloak with a pre-configured custom realm (representing a generic OIDC provider)
- Fuego (FHIR HTTP server)
- Control Panel (web application for administrators)

But you can also deploy individual components by specifying the `enabled` value in the `provision.<component>` section of the `values.yaml` file. For example, to deploy only Fuego and the Control Panel, you can use the following value overrides:

```yaml
registryAuth:
  enabled: true
  username: "<username>"
  password: "<password>"
ingress:
  enabled: true
  host: apps.example.com
oidc:
  externalDiscoveryUrl: https://auth.example.com/.well-known/openid-configuration
provision:
  fuego:
    enabled: true
  panel:
    enabled: true
  keycloak:
    enabled: false
```
