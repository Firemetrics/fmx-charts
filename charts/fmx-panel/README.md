# fmx-panel

![Version: 0.1.36](https://img.shields.io/badge/Version-0.1.36-informational?style=flat-square)

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| caCertsConfigMap.enabled | bool | `false` |  |
| caCertsConfigMap.fileName | string | `"ca-certificates.crt"` |  |
| caCertsConfigMap.name | string | `"ca-certs"` |  |
| database.dbname | string | `"firemetrics"` |  |
| database.hostname | string | `"postgres"` |  |
| database.port | int | `5432` |  |
| database.userSecret | string | `"panel-user"` |  |
| datasetImportDisabled | bool | `false` |  |
| env | list | `[]` |  |
| fhir.baseUrl | string | `"https://example.com/fhir"` |  |
| image | string | `"ghcr.io/firemetrics/fmx-panel:ec65075"` |  |
| imagePullSecret | string | `""` |  |
| initContainers | list | `[]` |  |
| nocodeBuilderDisabled | bool | `false` |  |
| oidc.audience | string | `""` |  |
| oidc.clientId | string | `"panel"` |  |
| oidc.discoveryUrl | string | `""` |  |
| oidc.enabled | bool | `false` |  |
| publicPath | string | `"/panel"` |  |
| publicUrl | string | `"https://example.com/panel"` |  |
| resourceExplorerDisabled | bool | `false` |  |
| securityContext | object | `{}` |  |
| serviceAccountName | string | `""` |  |
| sqlEditorDisabled | bool | `false` |  |
| volumeMounts | list | `[]` |  |
| volumes | list | `[]` |  |

