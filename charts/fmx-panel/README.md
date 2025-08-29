# fmx-panel

![Version: 1.1.1](https://img.shields.io/badge/Version-1.1.1-informational?style=flat-square)

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
| env | list | `[]` |  |
| featureFlags | list | `[]` | The features enabled in the Panel. |
| fhir.baseUrl | string | `"https://example.com/fhir"` |  |
| image | string | `"ghcr.io/firemetrics/fmx-panel:acbc771"` |  |
| imagePullSecret | string | `""` |  |
| initContainers | list | `[]` |  |
| oidc.audience | string | `""` | The OIDC audience used by the FMX Panel. Defaults to the Panel's public URL. |
| oidc.clientId | string | `"panel"` |  |
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

