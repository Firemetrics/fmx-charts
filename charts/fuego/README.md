# fuego

![Version: 1.9.3](https://img.shields.io/badge/Version-1.9.3-informational?style=flat-square)

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
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
| database.userSecret | string | `"fuego-user"` |  |
| env | list | `[]` |  |
| hapi.enabled | bool | `true` |  |
| hapi.env | list | `[]` |  |
| hapi.features.validation.enabled | bool | `true` |  |
| hapi.image | string | `"ghcr.io/firemetrics/fmx-hapi-facade:0.1.6"` |  |
| hapi.initContainers | list | `[]` |  |
| hapi.oidc.clientSecret.idKey | string | `"id"` |  |
| hapi.oidc.clientSecret.name | string | `"hapi-oidc-client"` |  |
| hapi.oidc.clientSecret.secretKey | string | `"secret"` |  |
| hapi.oidc.discoveryUrl | string | `""` |  |
| hapi.oidc.enabled | bool | `false` |  |
| hapi.securityContext.allowPrivilegeEscalation | bool | `false` |  |
| hapi.securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| hapi.securityContext.readOnlyRootFilesystem | bool | `true` |  |
| hapi.securityContext.runAsNonRoot | bool | `true` |  |
| hapi.securityContext.runAsUser | int | `1000` |  |
| hapi.service.enabled | bool | `true` |  |
| hapi.service.nameOverride | string | `""` |  |
| hapi.serviceAccountName | string | `""` |  |
| hapi.volumeMounts | list | `[]` |  |
| hapi.volumes | list | `[]` |  |
| image | string | `"ghcr.io/firemetrics/fuego:dfb02edc"` |  |
| imagePullSecret | string | `""` |  |
| initContainers | list | `[]` |  |
| livenessProbe | object | `{}` |  |
| oidc.clientSecret.idKey | string | `"id"` |  |
| oidc.clientSecret.name | string | `"fuego-oidc-client"` |  |
| oidc.clientSecret.secretKey | string | `"secret"` |  |
| oidc.discoveryUrl | string | `""` |  |
| oidc.enabled | bool | `false` |  |
| publicUrl | string | `"http://example.com/fhir"` |  |
| readinessProbe | object | `{}` |  |
| securityContext.allowPrivilegeEscalation | bool | `false` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.readOnlyRootFilesystem | bool | `true` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| securityContext.runAsUser | int | `1000` |  |
| service.enabled | bool | `true` |  |
| service.nameOverride | string | `""` |  |
| serviceAccountName | string | `""` |  |
| volumeMounts | list | `[]` |  |
| volumes | list | `[]` |  |

