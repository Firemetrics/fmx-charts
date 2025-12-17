# fmx-grafana

![Version: 1.12.1](https://img.shields.io/badge/Version-1.12.1-informational?style=flat-square)

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| bootstrapDatabase.databaseUserSecret.name | string | `"grafana-bootstrap-db-user"` |  |
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
| database.userSecret.name | string | `"grafana-db-user"` |  |
| database.userSecret.passwordKey | string | `"password"` |  |
| database.userSecret.usernameKey | string | `"username"` |  |
| env | list | `[]` |  |
| image | string | `"ghcr.io/firemetrics/firemetrics-dashboards:01e5524"` |  |
| imagePullSecret | string | `""` |  |
| initContainers | list | `[]` |  |
| livenessProbe.failureThreshold | int | `30` |  |
| livenessProbe.httpGet.path | string | `"/api/health"` |  |
| livenessProbe.httpGet.port | int | `3000` |  |
| livenessProbe.periodSeconds | int | `10` |  |
| livenessProbe.timeoutSeconds | int | `30` |  |
| oidc.apiUrl | string | `"http://example.com/openid-connect/userinfo"` |  |
| oidc.authUrl | string | `"http://example.com/openid-connect/auth"` |  |
| oidc.clientSecret.idKey | string | `"id"` |  |
| oidc.clientSecret.name | string | `"grafana-oidc-client"` |  |
| oidc.clientSecret.secretKey | string | `"secret"` |  |
| oidc.enabled | bool | `false` |  |
| oidc.signoutUrl | string | `"http://example.com/openid-connect/logout"` |  |
| oidc.tokenUrl | string | `"http://example.com/openid-connect/token"` |  |
| persistence.enabled | bool | `true` |  |
| persistence.requestedStorage | string | `"2Gi"` |  |
| publicPath | string | `""` |  |
| readinessProbe.failureThreshold | int | `3` |  |
| readinessProbe.httpGet.path | string | `"/api/health"` |  |
| readinessProbe.httpGet.port | int | `3000` |  |
| readinessProbe.initialDelaySeconds | int | `5` |  |
| readinessProbe.periodSeconds | int | `10` |  |
| readinessProbe.timeoutSeconds | int | `30` |  |
| securityContext | object | `{}` |  |
| serverRootUrl | string | `"http://example.com/grafana/"` |  |
| service.enabled | bool | `true` |  |
| service.nameOverride | string | `""` |  |
| tls.enabled | bool | `false` |  |
| volumeMounts | list | `[]` |  |
| volumes | list | `[]` |  |

