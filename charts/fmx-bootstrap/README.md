# fmx-bootstrap

![Version: 1.9.3](https://img.shields.io/badge/Version-1.9.3-informational?style=flat-square)

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| database.dbname | string | `"firemetrics"` |  |
| database.hostname | string | `"postgres"` |  |
| database.port | int | `5432` |  |
| database.userSecret | string | `"firemetrics-bootstrap-user"` |  |
| image | string | `"ghcr.io/firemetrics/spilo17:4.0-p2-5128c164"` |  |
| imagePullSecret | string | `""` |  |
| jobNameOverride | string | `""` |  |
| securityContext | object | `{}` |  |

