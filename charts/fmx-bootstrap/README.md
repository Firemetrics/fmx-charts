# fmx-bootstrap

![Version: 1.12.0](https://img.shields.io/badge/Version-1.12.0-informational?style=flat-square)

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| database.dbname | string | `"firemetrics"` |  |
| database.hostname | string | `"postgres"` |  |
| database.port | int | `5432` |  |
| database.userSecret | string | `"firemetrics-bootstrap-user"` |  |
| image | string | `"ghcr.io/firemetrics/spilo17:4.0-p2-e849f807"` |  |
| imagePullSecret | string | `""` |  |
| jobNameOverride | string | `""` |  |
| securityContext | object | `{}` |  |

