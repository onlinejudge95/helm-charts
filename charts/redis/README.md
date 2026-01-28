# Redis Helm Chart

A Helm chart for deploying Redis with High Availability using Redis Sentinel on Kubernetes.

## Introduction

This chart bootstraps a Redis deployment on a Kubernetes cluster using the Helm package manager. It supports both standalone and high availability (HA) modes with Redis Sentinel for automatic failover.

## Features

- **High Availability**: Redis Sentinel for automatic master failover
- **Standalone Mode**: Simple single-instance deployment
- **Persistence**: Optional persistent storage with PVC
- **Authentication**: Password-based authentication
- **Configurable**: Extensive configuration options
- **Security**: Read-only root filesystem, non-root user
- **Monitoring**: Liveness and readiness probes

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- PersistentVolume provisioner support (if persistence is enabled)

## Installing the Chart

### Standalone Mode

```bash
helm install my-redis ./charts/redis --set architecture=standalone
```

### High Availability Mode (Recommended)

```bash
helm install my-redis ./charts/redis --set architecture=sentinel
```

## Uninstalling the Chart

```bash
helm uninstall my-redis
```

## Architecture

### Standalone Mode
- Single Redis instance
- Simple service exposure
- Suitable for development/testing

### High Availability Mode (Sentinel)
- 1 Redis master + N replicas (default: 3 total)
- 3+ Sentinel instances for monitoring and failover
- Automatic master election on failure
- Persistent storage for Sentinel state (recommended)
- Suitable for production

> **Note**: Sentinel persistence is enabled by default to preserve failover history and replica knowledge across pod restarts. This improves stability during recovery scenarios.

## Parameters

### Global Parameters

| Name                      | Description                                     | Value           |
| ------------------------- | ----------------------------------------------- | --------------- |
| `architecture`            | Redis architecture (standalone or sentinel)     | `sentinel`      |
| `replicaCount`            | Number of Redis replicas (including master)     | `3`             |
| `clusterDomain`           | Kubernetes cluster domain                       | `cluster.local` |
| `nameOverride`            | String to partially override redis.name         | `""`            |
| `fullnameOverride`        | String to fully override redis.fullname         | `""`            |

> **Note**: The `architecture` parameter is validated and must be either `standalone` or `sentinel`. Invalid values will cause deployment to fail with a clear error message.

### Image Parameters

| Name                | Description                          | Value           |
| ------------------- | ------------------------------------ | --------------- |
| `image.repository`  | Redis image repository               | `redis`         |
| `image.pullPolicy`  | Redis image pull policy              | `IfNotPresent`  |
| `image.tag`         | Redis image tag                      | `""`            |
| `imagePullSecrets`  | Image pull secrets                   | `[]`            |

### Service Parameters

| Name                      | Description                          | Value       |
| ------------------------- | ------------------------------------ | ----------- |
| `service.type`            | Kubernetes service type              | `ClusterIP` |
| `service.port`            | Redis port                           | `6379`      |
| `service.annotations`     | Service annotations                  | `{}`        |

### Authentication Parameters

| Name                              | Description                              | Value            |
| --------------------------------- | ---------------------------------------- | ---------------- |
| `auth.enabled`                    | Enable password authentication           | `true`           |
| `auth.password`                   | Redis password                           | `""`             |
| `auth.existingSecret`             | Use existing secret for password         | `""`             |
| `auth.passwordKey`                | Key in secret containing password        | `redis-password` |

> **Important**: The generated secret has the `helm.sh/resource-policy: keep` annotation, which prevents Helm from deleting it during upgrades. This ensures the password remains stable across upgrades and prevents connection breakage. If you need to change the password, you must manually delete the secret before upgrading.

### Redis Configuration Parameters

| Name                                  | Description                                  | Value              |
| ------------------------------------- | -------------------------------------------- | ------------------ |
| `redis.config`                        | Custom redis.conf configuration              | `""`               |
| `redis.maxMemory`                     | Max memory (e.g., "256mb", "1gb")            | `""`               |
| `redis.maxMemoryPolicy`               | Max memory policy                            | `noeviction`       |
| `redis.save`                          | RDB snapshot intervals                       | See values.yaml    |
| `redis.appendonly`                    | Enable AOF persistence                       | `yes`              |
| `redis.appendfsync`                   | AOF fsync policy                             | `everysec`         |
| `redis.extraEnv`                      | Additional environment variables             | `[]`               |

### Sentinel Configuration Parameters (HA Mode)

| Name                                  | Description                                  | Value              |
| ------------------------------------- | -------------------------------------------- | ------------------ |
| `sentinel.enabled`                    | Enable Sentinel                              | `true`             |
| `sentinel.replicaCount`               | Number of Sentinel replicas                  | `3`                |
| `sentinel.quorum`                     | Minimum Sentinels for quorum                 | `2`                |
| `sentinel.port`                       | Sentinel port                                | `26379`            |
| `sentinel.downAfterMilliseconds`      | Time before marking master as down           | `5000`             |
| `sentinel.failoverTimeout`            | Failover timeout                             | `180000`           |
| `sentinel.parallelSyncs`              | Number of parallel syncs                     | `1`                |
| `sentinel.config`                     | Custom sentinel.conf configuration           | `""`               |
| `sentinel.livenessProbe.enabled`      | Enable Sentinel liveness probe               | `true`             |
| `sentinel.livenessProbe.initialDelaySeconds` | Initial delay for liveness probe      | `30`               |
| `sentinel.livenessProbe.periodSeconds`| Period for liveness probe                    | `10`               |
| `sentinel.livenessProbe.timeoutSeconds`| Timeout for liveness probe                  | `5`                |
| `sentinel.livenessProbe.failureThreshold`| Failure threshold for liveness probe     | `5`                |
| `sentinel.livenessProbe.successThreshold`| Success threshold for liveness probe     | `1`                |
| `sentinel.readinessProbe.enabled`     | Enable Sentinel readiness probe              | `true`             |
| `sentinel.readinessProbe.initialDelaySeconds`| Initial delay for readiness probe    | `10`               |
| `sentinel.readinessProbe.periodSeconds`| Period for readiness probe                  | `5`                |
| `sentinel.readinessProbe.timeoutSeconds`| Timeout for readiness probe                | `3`                |
| `sentinel.readinessProbe.failureThreshold`| Failure threshold for readiness probe   | `3`                |
| `sentinel.readinessProbe.successThreshold`| Success threshold for readiness probe   | `1`                |
| `sentinel.persistence.enabled`        | Enable persistence for Sentinel data         | `true`             |
| `sentinel.persistence.storageClass`   | PVC Storage Class for Sentinel               | `""`               |
| `sentinel.persistence.accessMode`     | PVC Access Mode for Sentinel                 | `ReadWriteOnce`    |
| `sentinel.persistence.size`           | PVC Storage Request for Sentinel             | `1Gi`              |
| `sentinel.persistence.annotations`    | PVC annotations for Sentinel                 | `{}`               |
| `sentinel.resources`                  | Sentinel resource limits                     | See values.yaml    |

### Persistence Parameters (Redis Data)

| Name                          | Description                              | Value           |
| ----------------------------- | ---------------------------------------- | --------------- |
| `persistence.enabled`         | Enable persistence using PVC             | `true`          |
| `persistence.storageClass`    | PVC Storage Class                        | `""`            |
| `persistence.accessMode`      | PVC Access Mode                          | `ReadWriteOnce` |
| `persistence.size`            | PVC Storage Request                      | `8Gi`           |
| `persistence.annotations`     | PVC annotations                          | `{}`            |

### Resource Parameters

| Name                    | Description                      | Value    |
| ----------------------- | -------------------------------- | -------- |
| `resources.limits.cpu`     | CPU resource limits           | `500m`   |
| `resources.limits.memory`  | Memory resource limits        | `512Mi`  |
| `resources.requests.cpu`   | CPU resource requests         | `100m`   |
| `resources.requests.memory`| Memory resource requests      | `128Mi`  |

### Security Parameters

| Name                                          | Description                                      | Value       |
| --------------------------------------------- | ------------------------------------------------ | ----------- |
| `podSecurityContext.fsGroup`                  | Group ID for the pod                             | `999`       |
| `securityContext.capabilities.drop`           | Linux capabilities to drop                       | `["ALL"]`   |
| `securityContext.readOnlyRootFilesystem`      | Mount root filesystem as read-only               | `true`      |
| `securityContext.runAsNonRoot`                | Run container as non-root user                   | `true`      |
| `securityContext.runAsUser`                   | User ID for the container                        | `999`       |

### Probe Parameters

| Name                                      | Description                          | Value     |
| ----------------------------------------- | ------------------------------------ | --------- |
| `livenessProbe.enabled`                   | Enable liveness probe                | `true`    |
| `livenessProbe.initialDelaySeconds`       | Initial delay seconds                | `30`      |
| `livenessProbe.periodSeconds`             | Period seconds                       | `10`      |
| `livenessProbe.timeoutSeconds`            | Timeout seconds                      | `5`       |
| `livenessProbe.failureThreshold`          | Failure threshold                    | `5`       |
| `readinessProbe.enabled`                  | Enable readiness probe               | `true`    |
| `readinessProbe.initialDelaySeconds`      | Initial delay seconds                | `10`      |
| `readinessProbe.periodSeconds`            | Period seconds                       | `5`       |
| `readinessProbe.timeoutSeconds`           | Timeout seconds                      | `3`       |
| `readinessProbe.failureThreshold`         | Failure threshold                    | `3`       |

### Other Parameters

| Name                | Description                      | Value           |
| ------------------- | -------------------------------- | --------------- |
| `podAnnotations`    | Pod annotations                  | `{}`            |
| `nodeSelector`      | Node labels for pod assignment   | `{}`            |
| `tolerations`       | Tolerations for pod assignment   | `[]`            |
| `affinity`          | Affinity for pod assignment      | `{}`            |
| `extraVolumes`      | Additional volumes               | `[]`            |
| `extraVolumeMounts` | Additional volume mounts         | `[]`            |
| `updateStrategy`    | StatefulSet update strategy      | `RollingUpdate` |

## Configuration Examples

### High Availability with Custom Resources

```yaml
architecture: sentinel
replicaCount: 3
sentinel:
  replicaCount: 3
  quorum: 2
resources:
  limits:
    cpu: 1000m
    memory: 1Gi
  requests:
    cpu: 200m
    memory: 256Mi
persistence:
  enabled: true
  size: 16Gi
```

### Standalone with Authentication

```yaml
architecture: standalone
replicaCount: 1
auth:
  enabled: true
  password: "my-secure-password"
persistence:
  enabled: true
  storageClass: "fast-ssd"
  size: 10Gi
```

### Production HA Setup

```yaml
architecture: sentinel
replicaCount: 5
sentinel:
  replicaCount: 5
  quorum: 3
auth:
  enabled: true
  password: "strong-password"
persistence:
  enabled: true
  storageClass: "ssd"
  size: 50Gi
redis:
  maxMemory: "2gb"
  maxMemoryPolicy: "allkeys-lru"
resources:
  limits:
    cpu: 2000m
    memory: 2Gi
  requests:
    cpu: 500m
    memory: 512Mi
```

## Accessing Redis

### Get Redis Password

```bash
export REDIS_PASSWORD=$(kubectl get secret my-redis-auth -o jsonpath='{.data.redis-password}' | base64 -d)
```

### Connect to Redis (HA Mode)

In Sentinel mode, clients should query Sentinel to discover the current master:

```bash
# Get master address from Sentinel
kubectl run redis-client --rm -it --restart=Never \
  --image=redis:7.2.4-alpine \
  --command -- redis-cli \
  -h my-redis-sentinel.default.svc.cluster.local \
  -p 26379 \
  sentinel get-master-addr-by-name my-redis-master

# Connect directly to the discovered master using its pod DNS
# Example: my-redis-0.my-redis-headless.default.svc.cluster.local
kubectl run redis-client --rm -it --restart=Never \
  --image=redis:7.2.4-alpine \
  --env REDISCLI_AUTH=$REDIS_PASSWORD \
  --command -- redis-cli \
  -h <master-pod-dns> \
  -p 6379
```

**Note**: The regular service (`my-redis`) routes to all Redis instances (master and replicas) and is suitable for:
- Read operations (can be served by replicas)
- Sentinel-aware clients that query Sentinel internally
- Load-balanced read traffic

For write operations, always use Sentinel to discover the current master.

### Connect to Redis (Standalone Mode)

```bash
kubectl run redis-client --rm -it --restart=Never \
  --image=redis:7.2.4-alpine \
  --env REDISCLI_AUTH=$REDIS_PASSWORD \
  --command -- redis-cli \
  -h my-redis.default.svc.cluster.local \
  -p 6379
```

## Testing Failover (HA Mode)

```bash
# Delete the master pod
kubectl delete pod my-redis-0

# Watch Sentinel promote a new master
kubectl exec -it my-redis-sentinel-0 -- \
  redis-cli -p 26379 sentinel masters

# Verify new master
kubectl exec -it my-redis-sentinel-0 -- \
  redis-cli -p 26379 sentinel get-master-addr-by-name my-redis-master
```

## Troubleshooting

### Check Redis Status

```bash
# Check pods
kubectl get pods -l app.kubernetes.io/name=redis

# Check logs
kubectl logs my-redis-0
kubectl logs my-redis-sentinel-0

# Check replication status (using REDISCLI_AUTH for security)
kubectl exec -it my-redis-0 --env REDISCLI_AUTH=$REDIS_PASSWORD -- \
  redis-cli info replication
```

### Check Sentinel Status

```bash
# Get all Sentinel masters
kubectl exec -it my-redis-sentinel-0 -- \
  redis-cli -p 26379 sentinel masters

# Get replicas for a master
kubectl exec -it my-redis-sentinel-0 -- \
  redis-cli -p 26379 sentinel replicas my-redis-master

# Get Sentinel info
kubectl exec -it my-redis-sentinel-0 -- \
  redis-cli -p 26379 info sentinel
```

## Upgrading

```bash
helm upgrade my-redis ./charts/redis
```

### Password Management During Upgrades

The Redis password secret is protected with the `helm.sh/resource-policy: keep` annotation. This means:

- **Password is preserved**: The secret will not be deleted or regenerated during `helm upgrade`
- **Existing connections continue working**: No disruption to applications using Redis
- **To change the password**: You must manually delete the secret before upgrading:

```bash
# Delete the secret
kubectl delete secret my-redis-auth

# Upgrade with new password
helm upgrade my-redis ./charts/redis --set auth.password="new-password"
```

## License

Copyright 2026 onlinejudge95

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
