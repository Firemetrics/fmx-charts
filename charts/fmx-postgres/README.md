# fmx-postgres

![Version: 1.9.3](https://img.shields.io/badge/Version-1.9.3-informational?style=flat-square)

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| backup.bucketName | string | `"backup"` | The name of the S3 bucket used for WAL archiving. |
| backup.enabled | bool | `false` | Enable WAL archiving for the Postgres cluster. |
| backup.endpoint | string | `"http://minio"` | The S3 bucket endpoint used for WAL archiving. |
| backup.region | string | `"auto"` | The S3 bucket region used for WAL archiving. |
| backup.userSecret.accessKeyKey | string | `"accessKey"` | The key in the secret containing the S3 access key. |
| backup.userSecret.name | string | `"backup-bucket-user"` | The secret containing the S3 user credentials for WAL archiving. |
| backup.userSecret.secretKeyKey | string | `"secretKey"` | The key in the secret containing the S3 secret key. |
| clusterNameOverride | string | `""` |  |
| env | list | `[]` |  |
| image | string | `"ghcr.io/firemetrics/spilo17:4.0-p2-5128c164"` |  |
| imagePullSecret | string | `""` |  |
| numberOfInstances | int | `1` |  |
| podServiceAccountNameOverride | string | `""` |  |
| postgresql.parameters."fmx.worker_count" | string | `"4"` |  |
| postgresql.parameters.max_locks_per_transaction | string | `"512"` |  |
| postgresql.parameters.shared_buffers | string | `"2GB"` |  |
| postgresql.parameters.shared_preload_libraries | string | `"bg_mon,pg_stat_statements,pgextwlist,pg_auth_mon,set_user,timescaledb,pg_cron,pg_stat_kcache,fhirql"` |  |
| postgresql.parameters.work_mem | string | `"256MB"` |  |
| postgresql.version | string | `"16"` |  |
| resources.limits.cpu | string | `"32"` |  |
| resources.limits.memory | string | `"128Gi"` |  |
| resources.requests.cpu | string | `"10m"` |  |
| resources.requests.memory | string | `"100Mi"` |  |
| spiloFSGroup | int | `103` |  |
| spiloRunAsGroup | int | `103` |  |
| spiloRunAsUser | int | `101` |  |
| teamId | string | `""` |  |
| volume.size | string | `"10Gi"` |  |

