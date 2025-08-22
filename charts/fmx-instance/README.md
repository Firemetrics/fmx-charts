# fmx-instance

![Version: 0.1.34](https://img.shields.io/badge/Version-0.1.34-informational?style=flat-square)

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
| components.panel.datasetImportDisabled | bool | `false` | Disable the dataset import feature in the FMX Panel. |
| components.panel.enabled | bool | `true` | Enable the FMX Panel component. |
| components.panel.env | list | `[]` | Extra environment variables for the FMX Panel pods. |
| components.panel.image | string | `"ghcr.io/firemetrics/fmx-panel:ec65075"` | The image used for the FMX Panel pods. |
| components.panel.nocodeBuilderDisabled | bool | `false` | Disable the no-code builder feature in the FMX Panel. |
| components.panel.oidc.audience | string | `""` | The OIDC audience used by the FMX Panel. Defaults to the public URL of the FMX Panel. |
| components.panel.oidc.clientId | string | `"panel"` | Enable OIDC authentication for the FMX Panel. |
| components.panel.publicPath | string | `"/panel"` | The public path for the FMX Panel. |
| components.panel.resourceExplorerDisabled | bool | `false` | Disable the resource explorer feature in the FMX Panel. |
| components.panel.securityContext | object | `{}` | The security context for the FMX Panel pods. |
| components.panel.sqlEditorDisabled | bool | `false` | Disable the SQL editor feature in the FMX Panel. |
| components.panel.valuesOverride | object | `{}` | Override the values for the FMX Panel Helm chart. |
| components.panel.volumeMounts | list | `[]` | Extra volume mounts for the FMX Panel pods. |
| components.panel.volumes | list | `[]` | Extra volumes for the FMX Panel pods. |
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
| oidc.discoveryUrlOverride | string | `""` | The OIDC client ID for the Firemetrics instance. Defaults to Keycloak instance created by this chart. |
| oidc.enabled | bool | `true` | Enable OIDC authentication for the Firemetrics instance. |
| oidc.keycloakRealm | string | `"firemetrics"` | The Keycloak realm used for OIDC authentication. Only relevant if Keycloak is enabled. |
| spiloImage | string | `"ghcr.io/firemetrics/spilo17:4.0-p2-f0457965"` | The image used for the Spilo Postgres cluster pods. |
| syncPolicy | object | `{"automated":{"prune":true,"selfHeal":true}}` | The sync policy used for all applications created by this chart. |
| tls.certManager.enabled | bool | `false` | Enable cert-manager integration for automatic TLS certificate management. |
| tls.certManager.issuer | string | `"letsencrypt"` | Name of the cert-manager ClusterIssuer to use for TLS certificate issuance. |
| tls.enabled | bool | `false` | Enable TLS for the Firemetrics instance. |
| tls.existingSecret | bool | `false` | Disable automatic creation of the TLS secret. |
| tls.secretNameOverride | string | `""` | Name of the Kubernetes secret containing the TLS certificate and key. Defaults to "{prefix}-tls-cert". |

