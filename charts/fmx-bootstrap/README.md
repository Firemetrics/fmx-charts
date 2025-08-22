# fmx-bootstrap

![Version: 0.1.33](https://img.shields.io/badge/Version-0.1.33-informational?style=flat-square)

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| database.dbname | string | `"firemetrics"` |  |
| database.hostname | string | `"postgres"` |  |
| database.port | int | `5432` |  |
| database.userSecret | string | `"firemetrics-bootstrap-user"` |  |
| firemetrics.workerCount | int | `1` |  |
| image | string | `"ghcr.io/firemetrics/spilo16:3.3-p2-f0457965"` |  |
| imagePullSecret | string | `""` |  |
| jobNameOverride | string | `""` |  |
| securityContext | object | `{}` |  |

