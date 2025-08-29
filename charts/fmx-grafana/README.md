# fmx-grafana

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square)

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| adminSecret.name | string | `"grafana-admin"` |  |
| adminSecret.passwordKey | string | `"password"` |  |
| adminSecret.usernameKey | string | `"username"` |  |
| bootstrap.databaseUserSecret.name | string | `"grafana-bootstrap-db-user"` |  |
| bootstrap.databaseUserSecret.passwordKey | string | `"password"` |  |
| bootstrap.databaseUserSecret.usernameKey | string | `"username"` |  |
| bootstrap.enabled | bool | `false` |  |
| bootstrap.image | string | `"ghcr.io/zalando/spilo-17:4.0-p2"` |  |
| database.dbname | string | `"firemetrics"` |  |
| database.hostname | string | `"postgres"` |  |
| database.port | int | `5432` |  |
| database.userSecret.name | string | `"grafana-db-user"` |  |
| database.userSecret.passwordKey | string | `"password"` |  |
| database.userSecret.usernameKey | string | `"username"` |  |
| env | list | `[]` |  |
| hostname | string | `"example.com"` |  |
| image | string | `"ghcr.io/firemetrics/firemetrics-dashboards:latest"` |  |
| imagePullSecret | string | `""` |  |
| initContainers | list | `[]` |  |
| publicPath | string | `"/grafana"` |  |
| securityContext | object | `{}` |  |
| service.enabled | bool | `true` |  |
| service.nameOverride | string | `""` |  |
| volumeMounts | list | `[]` |  |
| volumes | list | `[]` |  |

