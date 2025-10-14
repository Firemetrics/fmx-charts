# fmx-dicom

![Version: 1.7.0](https://img.shields.io/badge/Version-1.7.0-informational?style=flat-square)

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
| receiver.enabled | bool | `true` | Enable the DICOM receiver component. |
| receiver.env | list | `[]` | Extra environment variables for the DICOM receiver. |
| receiver.exposedService.enabled | bool | `false` | Enable the creation of an exposed service for direct DICOM receiver access. |
| receiver.exposedService.servicePort | int | `11112` | The service port for the exposed DICOM receiver service. |
| receiver.exposedService.serviceType | string | `"LoadBalancer"` | The service type for the exposed DICOM receiver service. |
| receiver.image | string | `"ghcr.io/firemetrics/dicom_receiver:0a76e7d2"` | The image used for the DICOM receiver. |
| receiver.initContainers | list | `[]` | Extra init containers for the DICOM receiver. |
| receiver.migration.enabled | bool | `false` | Enable the migration init container to run database migrations before starting the receiver. |
| receiver.volumeMounts | list | `[]` | Extra volume mounts for the DICOM receiver. |
| receiver.volumes | list | `[]` | Extra volumes for the DICOM receiver. |
| s3.bucketName | string | `"dicom"` | The S3 bucket name for DICOM files. |
| s3.enabled | bool | `false` | Enable S3 storage for DICOM files. |
| s3.endpoint | string | `"http://minio"` | The S3 bucket endpoint URL. |
| s3.endpointSyntax | string | `"path"` | The S3 endpoint syntax style (path or vhost). |
| s3.region | string | `"auto"` | The S3 bucket region. |
| s3.userSecret.accessKeyKey | string | `"accessKey"` | The key in the secret containing the S3 access key. |
| s3.userSecret.name | string | `"minio-user"` | The secret containing S3 user credentials. |
| s3.userSecret.secretKeyKey | string | `"secretKey"` | The key in the secret containing the S3 secret key. |
| securityContext | object | `{}` |  |
| serviceAccountName | string | `""` |  |

