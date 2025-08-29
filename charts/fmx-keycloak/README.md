# fmx-keycloak

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square)

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| adminSecret.name | string | `"keycloak-admin"` |  |
| adminSecret.passwordKey | string | `"password"` |  |
| adminSecret.usernameKey | string | `"username"` |  |
| bootstrap.databaseUserSecret.name | string | `"keycloak-bootstrap-db-user"` |  |
| bootstrap.databaseUserSecret.passwordKey | string | `"password"` |  |
| bootstrap.databaseUserSecret.usernameKey | string | `"username"` |  |
| bootstrap.enabled | bool | `true` |  |
| bootstrap.image | string | `"ghcr.io/zalando/spilo-17:4.0-p2"` |  |
| database.dbname | string | `"keycloak"` |  |
| database.hostname | string | `"postgres"` |  |
| database.port | int | `5432` |  |
| database.userSecret.name | string | `"keycloak-db-user"` |  |
| database.userSecret.passwordKey | string | `"password"` |  |
| database.userSecret.usernameKey | string | `"username"` |  |
| env | list | `[]` |  |
| fuego.oidcAudience | string | `"fuego"` |  |
| hostname | string | `"example.com"` |  |
| image | string | `"quay.io/keycloak/keycloak:26.3.2"` |  |
| imagePullSecret | string | `""` |  |
| importRealm.enabled | bool | `true` |  |
| importRealm.realmName | string | `"firemetrics"` |  |
| initContainers | list | `[]` |  |
| panel.clientId | string | `"panel"` |  |
| panel.oidcAudience | string | `"panel"` |  |
| panel.publicUrl | string | `""` |  |
| persistence.enabled | bool | `true` |  |
| persistence.size | string | `"1Gi"` |  |
| publicPath | string | `"/auth"` |  |
| securityContext | object | `{}` |  |
| service.enabled | bool | `true` |  |
| service.nameOverride | string | `""` |  |
| volumeMounts | list | `[]` |  |
| volumes | list | `[]` |  |

