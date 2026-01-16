# fmx-postgres

![Version: 1.13.2](https://img.shields.io/badge/Version-1.13.2-informational?style=flat-square)

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| allowedSourceRanges | list | `[]` | List of CIDR blocks allowed to access the Postgres cluster if `enableMasterLoadBalancer` is true. Use `["0.0.0.0/0"]` to allow access from anywhere. |
| backup.bucketName | string | `"backup"` | The name of the S3 bucket used for WAL archiving. |
| backup.enabled | bool | `false` | Enable WAL archiving for the Postgres cluster. |
| backup.endpoint | string | `"http://minio"` | The S3 bucket endpoint used for WAL archiving. |
| backup.region | string | `"auto"` | The S3 bucket region used for WAL archiving. |
| backup.userSecret.accessKeyKey | string | `"accessKey"` | The key in the secret containing the S3 access key. |
| backup.userSecret.name | string | `"backup-bucket-user"` | The secret containing the S3 user credentials for WAL archiving. |
| backup.userSecret.secretKeyKey | string | `"secretKey"` | The key in the secret containing the S3 secret key. |
| clusterNameOverride | string | `""` |  |
| enableMasterLoadBalancer | bool | `false` | Enable the creation of a LoadBalancer service for the Postgres master pod. |
| enableReplicaLoadBalancer | bool | `false` | Enable the creation of a LoadBalancer service for the Postgres master pod. |
| env | list | `[]` |  |
| image | string | `"ghcr.io/firemetrics/spilo17:4.0-p2-v0.6.0"` |  |
| imagePullSecret | string | `""` |  |
| numberOfInstances | int | `1` |  |
| podServiceAccountNameOverride | string | `""` |  |
| postgresql.parameters."fmx.enforce_referential_integrity_on_delete" | string | `"false"` |  |
| postgresql.parameters."fmx.enforce_referential_integrity_on_write" | string | `"false"` |  |
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

