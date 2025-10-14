# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository contains Helm charts for deploying the Firemetrics ecosystem, a comprehensive healthcare metrics platform. The main chart is `fmx-instance` which orchestrates multiple microservices including Keycloak for authentication, PostgreSQL databases, Grafana for visualization, and custom Firemetrics components like Panel and Fuego.

## Architecture Pattern: App of Apps

This repository implements Argo CD's **App of Apps pattern**, where `fmx-instance` serves as the parent application that manages multiple child applications:

### Parent Application
- **fmx-instance**: The umbrella chart that orchestrates the entire Firemetrics ecosystem
- Provides centralized configuration through a single `values.yaml`
- Manages deployment order and service interdependencies
- Creates individual Argo CD Applications for each component

### Child Applications
Each template in `charts/fmx-instance/templates/` creates a dedicated Argo CD Application:
- **postgres**: PostgreSQL database cluster (Zalando Postgres Operator)
- **keycloak**: OIDC authentication service
- **fuego**: API backend service
- **panel**: Web UI component
- **grafana**: Monitoring and dashboards
- **bootstrap**: Database initialization and schema management
- **ingress**: Traefik ingress controller configuration
- **minio**: Object storage
- **dicom**: DICOM services

### Benefits of This Pattern
- **Single Deployment Point**: Deploy entire stack with one parent application
- **Configuration Propagation**: Shared values (hostname, TLS, OIDC) flow to all services
- **Dependency Management**: Proper orchestration of service startup and configuration
- **Environment Consistency**: Same pattern works across dev/staging/prod environments
- **Operational Simplicity**: Manage complex microservice ecosystem through unified interface

## Repository Structure

```
charts/
├── fmx-bootstrap/     # Bootstrap chart for initial setup
├── fmx-dicom/         # DICOM services wrapper (receiver and future DICOM components)
├── fmx-grafana/       # Grafana configuration
├── fmx-ingress/       # Ingress controller setup
├── fmx-instance/      # Parent App of Apps chart (primary deployment entry point)
│   └── templates/     # Creates child Argo CD Applications for each component
├── fmx-keycloak/      # Keycloak authentication service
├── fmx-minio/         # MinIO object storage
├── fmx-panel/         # Panel UI component
├── fmx-postgres/      # PostgreSQL database
└── fuego/             # Fuego service chart

scripts/
├── package-and-upload-charts.sh  # Build and upload charts to Helm repo
└── release-charts.sh             # Version bump and release process
```

## Essential Commands

### Development and Testing
```bash
# Validate chart syntax
helm lint charts/fmx-instance/

# Dry run deployment to check template rendering
helm template test-release charts/fmx-instance/ --values charts/fmx-instance/values.yaml

# Package individual chart
helm package charts/fmx-instance/

# Generate chart documentation (ALWAYS run after changing values.yaml files)
helm-docs
```

### Release Management
```bash
# Create new release (bumps version, updates changelog, tags)
./scripts/release-charts.sh

# Package and upload all charts to repository
./scripts/package-and-upload-charts.sh
```

### Chart Dependencies
```bash
# Update chart dependencies
helm dependency update charts/fmx-instance/
```

## Configuration

The primary configuration is in `charts/fmx-instance/values.yaml`. Key configuration areas:
- **hostname**: Domain for the Firemetrics instance
- **tls**: TLS/SSL certificate configuration
- **ingress**: Traefik ingress controller settings
- **databases**: PostgreSQL operator configuration
- **authentication**: Keycloak OIDC settings
- **storage**: MinIO and backup configurations

## Prerequisites

Before deploying, ensure the target Kubernetes cluster has:
- Argo CD for GitOps deployment
- Traefik ingress controller
- Postgres Operator (Zalando)
- Cert-Manager (if using automatic TLS)
- MinIO-Operator (if using object storage)

## Secrets Management

The deployment requires several Kubernetes secrets to be created manually:
- `keycloak-admin` and `keycloak-db-user` for Keycloak
- `fuego-oidc-client` and `panel-oidc-client` for OIDC authentication
- `panel-db-user` and `grafana-db-user` for database access
- `grafana-oidc-client` for Grafana OIDC
- `docker-registry` for private image registry access
- `backup-bucket-user` for backup storage (if enabled)
- `dicom-receiver-db-user` for DICOM receiver database access (if enabled)

## Version Management

This project uses:
- **git-cliff** for changelog generation following conventional commits
- **helm-docs** for automatic chart documentation
- Semantic versioning with automatic version bumping
- Git tags for release tracking

## Architecture Notes

The `fmx-instance` chart implements the App of Apps pattern to coordinate multiple services through Argo CD Applications:

### Service Architecture Layers
1. **Authentication Layer**: Keycloak provides OIDC/OAuth2 authentication
2. **Data Layer**: PostgreSQL databases managed by Postgres Operator
3. **Application Layer**: Panel (UI), Fuego (API), and other microservices
4. **Observability**: Grafana with custom dashboards
5. **Storage**: MinIO for object storage and backups
6. **Networking**: Traefik for ingress and service mesh

### GitOps Deployment Flow
1. **Deploy Parent**: Install `fmx-instance` chart via Argo CD
2. **Child Creation**: Parent creates individual Applications for each service
3. **Dependency Chain**: Services deploy in proper order (postgres → keycloak → apps)
4. **Configuration Sync**: Shared values propagate to all child applications
5. **Health Monitoring**: Argo CD tracks health of entire ecosystem

### Key Dependencies
- **Keycloak** depends on PostgreSQL for user/session storage
- **Panel/Fuego** depend on Keycloak for OIDC authentication
- **Grafana** depends on PostgreSQL for configuration storage
- **Bootstrap** must run after PostgreSQL to initialize schemas
- **All services** depend on ingress for external access
