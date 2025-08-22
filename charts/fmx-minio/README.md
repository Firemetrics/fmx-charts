# fmx-minio

![Version: 0.1.35](https://img.shields.io/badge/Version-0.1.35-informational?style=flat-square)

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
| tenantNameOverride | string | `""` |  |
| volumesPerServer | int | `1` |  |

