# Firemetrics Helm Charts

Helm charts for deploying the Firemetrics ecosystem.

## Prerequisites

The following cluster components are required for the Firemetrics ecosystem to function properly:

- [Argo CD](https://argo-cd.readthedocs.io/en/stable/)
- [Cert-Manager](https://cert-manager.io/docs/installation/)
- [Traefik ingress controller](https://doc.traefik.io/traefik/getting-started/quick-start-with-kubernetes/).
- [Postgres Operator](https://github.com/zalando/postgres-operator/blob/master/docs/quickstart.md#deployment-options)

## Installation

Create a secret for access to the `ghcr.io` registry:

```bash
kubectl -n <namespace> create secret docker-registry \
  --docker-username user \
  --docker-password <token> \
  docker-registry
```

Then create an Argo CD application for the `fmx-instance` chart:

```bash
argocd app create fmx \
  --repo https://nexus.firemetricshealth.com/repository/helm-firemetrics/ \
  --helm-chart fmx-instance \
  --revision 'x.x.x' \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace <namespace> \
  --parameter imagePullSecret=docker-registry
argocd app sync fmx
```

