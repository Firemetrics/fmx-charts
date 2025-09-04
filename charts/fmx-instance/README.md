# fmx-instance

![Version: 1.4.2](https://img.shields.io/badge/Version-1.4.2-informational?style=flat-square)

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| argoCdNamespace | string | `"argocd"` | The namespace where Argo CD is installed. |
| backup.bucketName | string | `"backup"` | The name of the S3 bucket used for WAL archiving. |
| backup.enabled | bool | `false` | Enable WAL archiving for the Postgres cluster. |
| backup.endpoint | string | `"http://minio"` | The S3 bucket endpoint used for WAL archiving. |
| backup.region | string | `"auto"` | The S3 bucket region used for WAL archiving. |
| backup.userSecret.accessKeyKey | string | `"accessKey"` | The key in the secret containing the S3 access key. |
| backup.userSecret.name | string | `"backup-bucket-user"` | The secret containing the S3 user credentials for WAL archiving. |
| backup.userSecret.secretKeyKey | string | `"secretKey"` | The key in the secret containing the S3 secret key. |
| caCertsConfigMap.data | string | `""` | The content of the CA certificates. If empty, `caCertsConfigMap.existingConfigMap` must be set to true. |
| caCertsConfigMap.enabled | bool | `false` | Enable the creation of a ConfigMap containing CA certificates. |
| caCertsConfigMap.existingConfigMap | bool | `false` | Disable automatic creation of the CA certificates ConfigMap. |
| caCertsConfigMap.fileName | string | `"ca-certificates.crt"` | The file name of the CA certificates in the ConfigMap. |
| caCertsConfigMap.nameOverride | string | `""` | Name of the ConfigMap containing CA certificates. Defaults to "{prefix}-ca-certs". |
| chartRepoUrl | string | `"https://nexus.firemetricshealth.com/repository/helm-firemetrics/"` | The URL of the Firemetrics Helm charts repository. |
| chartRevisionOverride | string | `""` | The version of the Firemetrics Helm charts to use. Defaults to the current chart's version. |
| components.bootstrap.enabled | bool | `true` | Enable the database bootstrap job. |
| components.bootstrap.firemetrics.workerCount | int | `1` | The number of worker processes to start in the bootstrap job. |
| components.bootstrap.securityContext | object | `{}` | The security context for the bootstrap job. |
| components.bootstrap.valuesOverride | object | `{}` | Override the values for the bootstrap job Helm chart. |
| components.fuego.enabled | bool | `true` | Enable the Fuego component. |
| components.fuego.env | list | `[]` | Extra environment variables for the Fuego pods. |
| components.fuego.image | string | `"ghcr.io/firemetrics/fuego:dfb02edc"` | The image used for the Fuego pods. |
| components.fuego.oidcClientSecret.idKey | string | `"id"` | The key in the secret containing the OIDC client ID. |
| components.fuego.oidcClientSecret.name | string | `"fuego-oidc-client"` | The secret containing the OIDC client credentials for Fuego. |
| components.fuego.oidcClientSecret.secretKey | string | `"secret"` | The key in the secret containing the OIDC client secret. |
| components.fuego.securityContext | object | `{}` | The security context for the Fuego pods. |
| components.fuego.valuesOverride | object | `{}` | Override the values for the Fuego Helm chart. |
| components.fuego.volumeMounts | list | `[]` | Extra volume mounts for the Fuego pods. |
| components.fuego.volumes | list | `[]` | Extra volumes for the Fuego pods. |
| components.grafana.databaseUserSecret.name | string | `"grafana-db-user"` | The secret containing Grafana database user credentials. |
| components.grafana.databaseUserSecret.passwordKey | string | `"password"` | The key in the secret containing the Grafana database password. |
| components.grafana.databaseUserSecret.usernameKey | string | `"username"` | The key in the secret containing the Grafana database username. |
| components.grafana.enabled | bool | `true` | Enable the Grafana component. |
| components.grafana.env | list | `[]` | Extra environment variables for Grafana pods. |
| components.grafana.image | string | `"ghcr.io/firemetrics/firemetrics-dashboards:828d4b0"` | The image used for Grafana pods. |
| components.grafana.oidcClientSecret.idKey | string | `"id"` | The key in the secret containing the OIDC client ID. |
| components.grafana.oidcClientSecret.name | string | `"grafana-oidc-client"` | The secret containing the OIDC client credentials for Grafana. |
| components.grafana.oidcClientSecret.secretKey | string | `"secret"` | The key in the secret containing the OIDC client secret. |
| components.grafana.persistence.enabled | bool | `true` | Enable persistence for Grafana. |
| components.grafana.persistence.requestedStorage | string | `"2Gi"` | The size of the Grafana data volume. |
| components.grafana.publicPath | string | `"/grafana"` | The public path for Grafana. |
| components.grafana.securityContext | object | `{}` | The security context for Grafana pods. |
| components.grafana.valuesOverride | object | `{}` | Override the values for the Grafana Helm chart. |
| components.grafana.volumeMounts | list | `[]` | Extra volume mounts for Grafana pods. |
| components.grafana.volumes | list | `[]` | Extra volumes for Grafana pods. |
| components.ingress.enabled | bool | `true` | Enable the ingress component. |
| components.ingress.valuesOverride | object | `{}` | Override the values for the ingress Helm chart. |
| components.keycloak.adminSecret.name | string | `"keycloak-admin"` | The secret containing the Keycloak admin credentials. |
| components.keycloak.adminSecret.passwordKey | string | `"password"` | The key in the secret containing the Keycloak admin password. |
| components.keycloak.adminSecret.usernameKey | string | `"username"` | The key in the secret containing the Keycloak admin username. |
| components.keycloak.databaseName | string | `"keycloak"` | The database name used by Keycloak. |
| components.keycloak.databaseUserSecret.name | string | `"keycloak-db-user"` | The secret containing the Keycloak database user credentials. |
| components.keycloak.databaseUserSecret.passwordKey | string | `"password"` | The key in the secret containing the Keycloak database password. |
| components.keycloak.databaseUserSecret.usernameKey | string | `"username"` | The key in the secret containing the Keycloak database username. |
| components.keycloak.enabled | bool | `true` | Enable the Keycloak component. |
| components.keycloak.env | list | `[]` | Extra environment variables for the Keycloak pods. |
| components.keycloak.image | string | `"quay.io/keycloak/keycloak:26.3.2"` | The image used for the Keycloak pods. |
| components.keycloak.importRealm | bool | `true` | Enable realm initialization for Keycloak. |
| components.keycloak.publicPath | string | `"/auth"` | The public path for Keycloak. |
| components.keycloak.securityContext | object | `{}` | The security context for the Keycloak pods. |
| components.keycloak.valuesOverride | object | `{}` | Override the values for the Keycloak Helm chart. |
| components.keycloak.volumeMounts | list | `[]` | Extra volume mounts for the Keycloak pods. |
| components.keycloak.volumes | list | `[]` | Extra volumes for the Keycloak pods. |
| components.minio.chartRepoUrl | string | `"https://operator.min.io"` | The image used for the MinIO pods. |
| components.minio.configSecretName | string | `"minio-config"` | The configuration secret for MinIO. |
| components.minio.enabled | bool | `false` | Enable the MinIO component. |
| components.minio.size | string | `"10Gi"` | The size of the MinIO data volume. |
| components.minio.valuesOverride | object | `{}` | Override the values for the MinIO Helm chart. |
| components.panel.databaseUserSecret.name | string | `"panel-db-user"` | The secret containing Panel database user credentials. |
| components.panel.databaseUserSecret.passwordKey | string | `"password"` | The key in the secret containing the Panel database password. |
| components.panel.databaseUserSecret.usernameKey | string | `"username"` | The key in the secret containing the Panel database username. |
| components.panel.enabled | bool | `true` | Enable the Panel component. |
| components.panel.env | list | `[]` | Extra environment variables for the Panel pods. |
| components.panel.featureFlags | list | `[]` | The features enabled in the Panel. |
| components.panel.image | string | `"ghcr.io/firemetrics/fmx-panel:v1.0.3"` | The image used for the Panel pods. |
| components.panel.oidc.audience | string | `""` | The OIDC audience used by the Panel. Defaults to the public URL of the Panel. |
| components.panel.oidc.clientSecret.idKey | string | `"id"` | The key in the secret containing the OIDC client ID. |
| components.panel.oidc.clientSecret.name | string | `"panel-oidc-client"` | The secret containing the OIDC client credentials for Panel. |
| components.panel.oidc.clientSecret.secretKey | string | `"secret"` | The key in the secret containing the OIDC client secret. |
| components.panel.openaiApiKeySecret.enabled | bool | `false` | Enable the OpenAI API key for the Panel. |
| components.panel.openaiApiKeySecret.key | string | `"api-key"` | The key in the secret containing the OpenAI API key for the Panel. |
| components.panel.openaiApiKeySecret.name | string | `"openai-api-key"` | The secret containing the OpenAI API key for the Panel. |
| components.panel.publicPath | string | `"/panel"` | The public path for the Panel. |
| components.panel.securityContext | object | `{}` | The security context for the Panel pods. |
| components.panel.valuesOverride | object | `{}` | Override the values for the Panel Helm chart. |
| components.panel.volumeMounts | list | `[]` | Extra volume mounts for the Panel pods. |
| components.panel.volumes | list | `[]` | Extra volumes for the Panel pods. |
| components.postgres.clusterNameOverride | string | `""` | The name of the Postgres cluster. Defaults to "{prefix}-postgres". |
| components.postgres.enabled | bool | `true` | Enable the Postgres cluster managed by Postgres Operator. |
| components.postgres.extraEnv | list | `[]` | Extra environment variables for the Postgres cluster pods. |
| components.postgres.numberOfInstances | int | `1` | The number of Postgres instances in the cluster. |
| components.postgres.podServiceAccountNameOverride | string | `""` | The name of the Postgres cluster. Defaults to "postgres-pod". |
| components.postgres.postgresql | object | `{"parameters":{"max_locks_per_transaction":"512","shared_buffers":"2GB","work_mem":"256MB"},"version":"17"}` | The [PostgreSQL parameters](https://github.com/zalando/postgres-operator/blob/v1.14.0/docs/reference/cluster_manifest.md#postgres-parameters). |
| components.postgres.resources | object | `{"limits":{"cpu":"32","memory":"128Gi"},"requests":{"cpu":"10m","memory":"100Mi"}}` | The resource requests and limits for the Postgres cluster pods. |
| components.postgres.spiloFSGroup | int | `103` |  |
| components.postgres.spiloRunAsGroup | int | `103` |  |
| components.postgres.spiloRunAsUser | int | `101` |  |
| components.postgres.teamId | string | `""` | The name of the team that owns the Postgres cluster. |
| components.postgres.valuesOverride | object | `{}` | Override the values for the Postgres cluster Helm chart. |
| components.postgres.volume.size | string | `"10Gi"` | The size of the Postgres data volume. |
| database.dbname | string | `"firemetrics"` | The database name used by the Firemetrics instance. |
| database.existingSuperUserSecret | string | `""` | The database super user used by the Firemetrics instance to manage the Postgres instance. Defaults to the user created by Postgres Operator. |
| database.hostnameOverride | string | `""` | The database host used by the Firemetrics instance. Defaults to the Postgres cluster created by this chart. |
| database.port | int | `5432` | The database port used by the Firemetrics instance. |
| hostname | string | `"example.com"` | The hostname for the Firemetrics instance. |
| imagePullSecret | string | `""` | The image pull secret used for the Firemetrics instance. |
| oidc.authUrlOverride | string | `""` | The OIDC authentication URL. Defaults to the Keycloak instance created by this chart. |
| oidc.discoveryUrlOverride | string | `""` | The OIDC discovery URL. Defaults to the Keycloak instance created by this chart. |
| oidc.enabled | bool | `true` | Enable OIDC authentication for the Firemetrics instance. |
| oidc.keycloakRealm | string | `"firemetrics"` | The Keycloak realm used for OIDC authentication. Only relevant if Keycloak is enabled. |
| oidc.signoutUrlOverride | string | `""` | The OIDC sign-out URL. Defaults to the Keycloak instance created by this chart. |
| oidc.tokenUrlOverride | string | `""` | The OIDC token URL. Defaults to the Keycloak instance created by this chart. |
| oidc.userinfoUrlOverride | string | `""` | The OIDC user info URL. Defaults to the Keycloak instance created by this chart. |
| spiloImage | string | `"ghcr.io/firemetrics/spilo17:4.0-p2-f0457965"` | The image used for the Spilo Postgres cluster pods. |
| syncPolicy | object | `{"automated":{"prune":false,"selfHeal":false}}` | The sync policy used for all applications created by this chart. |
| tls.certManager.enabled | bool | `false` | Enable cert-manager integration for automatic TLS certificate management. |
| tls.certManager.issuer | string | `"letsencrypt"` | Name of the cert-manager ClusterIssuer to use for TLS certificate issuance. |
| tls.enabled | bool | `false` | Enable TLS for the Firemetrics instance. |
| tls.existingSecret | bool | `false` | Disable automatic creation of the TLS secret. |
| tls.secretNameOverride | string | `""` | Name of the Kubernetes secret containing the TLS certificate and key. Defaults to "{prefix}-tls-cert". |

