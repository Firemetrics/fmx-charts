# fmx-ingress

![Version: 1.14.0](https://img.shields.io/badge/Version-1.14.0-informational?style=flat-square)

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| hostname | string | `"example.com"` |  |
| services.fuego.enabled | bool | `true` |  |
| services.fuego.hapi.enabled | bool | `true` |  |
| services.fuego.hapi.name | string | `"fuego-hapi"` |  |
| services.fuego.name | string | `"fuego"` |  |
| services.fuego.path | string | `"/fhir"` |  |
| services.grafana.enabled | bool | `true` |  |
| services.grafana.name | string | `"grafana"` |  |
| services.grafana.path | string | `"/grafana"` |  |
| services.keycloak.enabled | bool | `false` |  |
| services.keycloak.name | string | `"keycloak"` |  |
| services.keycloak.path | string | `"/auth"` |  |
| services.panel.enabled | bool | `true` |  |
| services.panel.name | string | `"fmx-panel"` |  |
| services.panel.path | string | `"/panel"` |  |
| tls.enabled | bool | `false` |  |
| tls.secretName | string | `"tls-cert"` |  |

