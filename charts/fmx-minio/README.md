# fmx-minio

![Version: 0.1.33](https://img.shields.io/badge/Version-0.1.33-informational?style=flat-square)

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| adminSecret.accessKeyKey | string | `"accessKey"` |  |
| adminSecret.name | string | `"minio-admin"` |  |
| adminSecret.secretKeyKey | string | `"secretKey"` |  |
| application.chartRepoUrl | string | `"https://operator.min.io"` |  |
| application.chartVersion | string | `"7.1.1"` |  |
| application.nameOverride | string | `""` |  |
| application.syncPolicy.automated.prune | bool | `true` |  |
| application.syncPolicy.automated.selfHeal | bool | `true` |  |
| application.valuesOverride | object | `{}` |  |
| argoCdNamespace | string | `"argocd"` |  |
| backup.bucketName | string | `"backup"` |  |
| backup.enabled | bool | `true` |  |
| poolName | string | `"pool-0"` |  |
| servers | int | `1` |  |
| size | string | `"10Gi"` |  |
| tenantNameOverride | string | `""` |  |
| volumesPerServer | int | `1` |  |

