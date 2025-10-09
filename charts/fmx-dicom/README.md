# fmx-dicom

![Version: 1.6.0](https://img.shields.io/badge/Version-1.6.0-informational?style=flat-square)

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| caCertsConfigMap.enabled | bool | `false` |  |
| caCertsConfigMap.fileName | string | `"ca-certificates.crt"` |  |
| caCertsConfigMap.name | string | `"ca-certs"` |  |
| imagePullSecret | string | `""` |  |
| receiver.bootstrapDatabase.databaseUserSecret.name | string | `"dicom-receiver-bootstrap-db-user"` |  |
| receiver.bootstrapDatabase.databaseUserSecret.passwordKey | string | `"password"` |  |
| receiver.bootstrapDatabase.databaseUserSecret.usernameKey | string | `"username"` |  |
| receiver.bootstrapDatabase.enabled | bool | `false` |  |
| receiver.bootstrapDatabase.image | string | `"ghcr.io/zalando/spilo-17:4.0-p2"` |  |
| receiver.database.dbname | string | `"postgres"` |  |
| receiver.database.hostname | string | `"postgres"` |  |
| receiver.database.port | int | `5432` |  |
| receiver.database.schema | string | `"dicom"` |  |
| receiver.database.userSecret.name | string | `"dicom-receiver-db-user"` |  |
| receiver.database.userSecret.passwordKey | string | `"password"` |  |
| receiver.database.userSecret.usernameKey | string | `"username"` |  |
| receiver.dicom.aet | string | `"FMX"` | The Application Entity Title (AET) for the DICOM receiver. |
| receiver.dicom.logLevel | string | `"INFO"` | The log level for the DICOM receiver. |
| receiver.dicom.numThreads | int | `8` | The number of worker threads for the DICOM receiver. |
| receiver.dicom.port | int | `11112` | The port for the DICOM receiver. |
| receiver.enabled | bool | `true` | Enable the DICOM receiver component. |
| receiver.env | list | `[]` | Extra environment variables for the DICOM receiver. |
| receiver.image | string | `"ghcr.io/firemetrics/dicom_receiver:f489565f"` | The image used for the DICOM receiver. |
| receiver.initContainers | list | `[]` | Extra init containers for the DICOM receiver. |
| receiver.service.nodePort | string | `""` | The node port for the DICOM receiver service (optional, only used when type is NodePort). |
| receiver.service.type | string | `"NodePort"` | The service type for the DICOM receiver. Use "NodePort" to expose on the node. |
| receiver.volumeMounts | list | `[]` | Extra volume mounts for the DICOM receiver. |
| receiver.volumes | list | `[]` | Extra volumes for the DICOM receiver. |
| securityContext | object | `{}` |  |
| serviceAccountName | string | `""` |  |

