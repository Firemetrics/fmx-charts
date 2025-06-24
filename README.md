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

To install the Firemetrics chart, you can use the following command. Make sure to replace `<username>` and `<password>` with your actual credentials for the Firemetrics Docker registry.

```bash
helm install --namespace fmx --create-namespace fmx \
  --set 'registryAuth.enabled=true' \
  --set 'registryAuth.username=<username>' \
  --set 'registryAuth.password=<password>' \
  .
```

