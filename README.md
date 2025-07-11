# Firemetrics Helm Chart

A Helm chart for deploying the Firemetrics ecosystem.

## Prerequisites

### Traefik Ingress Controller

This chart assumes you have the [Traefik](https://traefik.io/) ingress controller installed in your Kubernetes cluster. You can install it using the following commands:

```bash
helm repo add traefik https://traefik.github.io/charts
helm repo update
helm install --namespace traefik --create-namespace traefik traefik/traefik
```

### Cert-Manager

This chart requires [cert-manager](https://cert-manager.io/) for managing TLS certificates. You can install it using the following commands:

```bash
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install --create-namespace cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v1.15.3 \
  --set crds.enabled=true
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

You can customize the chart by modifying the `values.yaml` file or by passing additional parameters to the `helm install` command. By default, the chart is configured to deploy the entire Firemetrics ecosystem, including:

- PostgreSQL ([Spilo](https://github.com/zalando/spilo)) database with the Firemetrics extension installed and bootstrapped
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
database:
  externalHostname: postgres.example.com
  dbname: "<dbname>"
  username: "<username>"
  password: "<password>"
  port: 5432
oidc:
  externalDiscoveryUrl: https://auth.example.com/.well-known/openid-configuration
provision:
  fuego:
    enabled: true
  panel:
    enabled: true
  spilo:
    enabled: false
  keycloak:
    enabled: false
```

Obviously, you will need to ensure that the external services (OIDC provider, PostgreSQL database) are properly configured and accessible from your Kubernetes cluster.
