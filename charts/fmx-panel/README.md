# fmx-panel

![Version: 1.13.0](https://img.shields.io/badge/Version-1.13.0-informational?style=flat-square)

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| bootstrapDatabase.databaseUserSecret.name | string | `"panel-bootstrap-db-user"` |  |
| bootstrapDatabase.databaseUserSecret.passwordKey | string | `"password"` |  |
| bootstrapDatabase.databaseUserSecret.usernameKey | string | `"username"` |  |
| bootstrapDatabase.enabled | bool | `false` |  |
| bootstrapDatabase.image | string | `"ghcr.io/zalando/spilo-17:4.0-p2"` |  |
| bootstrapKeycloak.adminUserSecret.name | string | `"keycloak-admin"` |  |
| bootstrapKeycloak.adminUserSecret.passwordKey | string | `"password"` |  |
| bootstrapKeycloak.adminUserSecret.usernameKey | string | `"username"` |  |
| bootstrapKeycloak.enabled | bool | `false` |  |
| bootstrapKeycloak.image | string | `"curlimages/curl:8.15.0"` |  |
| bootstrapKeycloak.realm | string | `"firemetrics"` |  |
| bootstrapKeycloak.url | string | `"https://example.com/auth"` |  |
| caCertsConfigMap.enabled | bool | `false` |  |
| caCertsConfigMap.fileName | string | `"ca-certificates.crt"` |  |
| caCertsConfigMap.name | string | `"ca-certs"` |  |
| database.dbname | string | `"firemetrics"` |  |
| database.hostname | string | `"postgres"` |  |
| database.port | int | `5432` |  |
| database.userSecret.name | string | `"panel-db-user"` |  |
| database.userSecret.passwordKey | string | `"password"` |  |
| database.userSecret.usernameKey | string | `"username"` |  |
| env | list | `[]` |  |
| featureFlags | list | `["resource_explorer","nocode_builder","sql_editor"]` | The features enabled in the Panel. |
| fhirBaseUrl | string | `"https://example.com/fhir"` |  |
| grafanaUrl | string | `""` |  |
| image | string | `"ghcr.io/firemetrics/fmx-panel:v1.3.0"` |  |
| imagePullSecret | string | `""` |  |
| initContainers | list | `[]` |  |
| oidc.audience | string | `""` | Defaults to the public URL. |
| oidc.clientSecret.idKey | string | `"id"` |  |
| oidc.clientSecret.name | string | `"panel-oidc-client"` |  |
| oidc.clientSecret.secretKey | string | `"secret"` |  |
| oidc.discoveryUrl | string | `""` |  |
| oidc.enabled | bool | `false` |  |
| openaiApiKeySecret.enabled | bool | `false` |  |
| openaiApiKeySecret.key | string | `"api-key"` |  |
| openaiApiKeySecret.name | string | `"openai-api-key"` |  |
| publicPath | string | `"/panel"` |  |
| publicUrl | string | `"https://example.com/panel"` |  |
| securityContext | object | `{}` |  |
| serviceAccountName | string | `""` |  |
| volumeMounts | list | `[]` |  |
| volumes | list | `[]` |  |

