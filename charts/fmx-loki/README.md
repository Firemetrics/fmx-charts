# fmx-loki

![Version: 1.13.3](https://img.shields.io/badge/Version-1.13.3-informational?style=flat-square)

Loki log aggregation with Alloy collector

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| alloy.config.jsonProcessing.labelFields | list | `["level"]` | Common fields: level, msg, message, error, caller, ts. |
| alloy.config.namespaces | list | `[]` | List of namespaces to collect logs from. Empty list means all namespaces. |
| alloy.enabled | bool | `true` | Enable Alloy log collector deployment. |
| alloy.image | string | `"grafana/alloy:v1.12.2"` | The image used for Alloy pods. |
| imagePullSecret | string | `""` | The image pull secret used for pulling images. |
| loki.config.retentionPeriod | string | `"744h"` | Log retention period (default: 31 days). |
| loki.enabled | bool | `true` | Enable Loki deployment. |
| loki.image | string | `"grafana/loki:3.4.2"` | The image used for Loki pods. |
| persistence.enabled | bool | `true` | Enable persistence for Loki data. |
| persistence.requestedStorage | string | `"10Gi"` | The size of the Loki data volume. |
| service.enabled | bool | `true` | Enable the Loki service. |
| service.nameOverride | string | `""` | Override the service name. |

