# reactive-resume

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 3.6.12](https://img.shields.io/badge/AppVersion-3.6.12-informational?style=flat-square)

Reactive Resume is a free and open source resume builder

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| EmailConfigSecretName | string | `nil` |  |
| GoogleAuthSecretName | string | `nil` |  |
| S3StorageSecretName | string | `nil` |  |
| affinity | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| env | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"ghcr.io/amruthpillai/reactive-resume"` |  |
| image.tag | string | `"3.6.12"` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| jwtExpiryTime | int | `604800` |  |
| jwtSecret | string | `nil` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| pdfDeletionTime | string | `nil` |  |
| podAnnotations | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| postgresDatabase | string | `"reactive-resume"` |  |
| postgresHost | string | `"postgres"` |  |
| postgresPassword | string | `"reactive-resume"` |  |
| postgresPasswordSecretName | string | `nil` |  |
| postgresPort | int | `5432` |  |
| postgresSslCert | string | `nil` |  |
| postgresUser | string | `"reactive-resume"` |  |
| postgresql.auth.database | string | `"reactive-resume"` |  |
| postgresql.auth.postgresPassword | string | `"reactive-resume"` |  |
| postgresql.enabled | bool | `true` |  |
| postgresql.primary.persistence.enabled | bool | `false` |  |
| publicServerUrl | string | `"http://localhost:3100"` |  |
| publicUrl | string | `"http://localhost:3000"` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| secretKey | string | `nil` |  |
| securityContext | object | `{}` |  |
| service.port | int | `80` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| sideCarContainers | list | `[]` |  |
| tolerations | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)