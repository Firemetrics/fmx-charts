# fmx-minio

![Version: 1.5.0](https://img.shields.io/badge/Version-1.5.0-informational?style=flat-square)

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| application.chartRepoUrl | string | `"https://operator.min.io"` |  |
| application.chartVersion | string | `"7.1.1"` |  |
| application.nameOverride | string | `""` |  |
| application.syncPolicy.automated.prune | bool | `true` |  |
| application.syncPolicy.automated.selfHeal | bool | `true` |  |
| application.valuesOverride | object | `{}` |  |
| argoCdNamespace | string | `"argocd"` |  |
| backup.bucketName | string | `"backup"` |  |
| backup.enabled | bool | `true` |  |
| configSecretName | string | `"minio-config"` |  |
| poolName | string | `"pool-0"` |  |
| servers | int | `1` |  |
| size | string | `"10Gi"` |  |
| tenantNameOverride | string | `""` | The name for the MinIO tenant. Defaults to the release's name. |
| volumesPerServer | int | `1` |  |

