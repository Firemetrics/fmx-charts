# fmx-minio

![Version: 1.14.0](https://img.shields.io/badge/Version-1.14.0-informational?style=flat-square)

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
| dicom.bucketName | string | `"dicom"` |  |
| dicom.enabled | bool | `true` |  |
| exposedService.enabled | bool | `false` | Enable the creation of an exposed service for direct MinIO access. |
| exposedService.servicePort | int | `9000` | The service port for the exposed MinIO service. |
| exposedService.serviceType | string | `"LoadBalancer"` | The service type for the exposed MinIO service. |
| poolName | string | `"pool-0"` |  |
| servers | int | `1` |  |
| size | string | `"10Gi"` |  |
| tenantNameOverride | string | `""` | The name for the MinIO tenant. Defaults to the release's name. |
| volumesPerServer | int | `1` |  |

