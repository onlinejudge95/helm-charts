# etcd Helm Chart

A Helm chart for deploying etcd - a distributed reliable key-value store for the most critical data of a distributed system.

## Introduction

This chart bootstraps an etcd cluster on a Kubernetes cluster using the Helm package manager. etcd is a strongly consistent, distributed key-value store that provides a reliable way to store data that needs to be accessed by a distributed system or cluster of machines.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- PersistentVolume provisioner support in the underlying infrastructure (if persistence is enabled)

## Installing the Chart

To install the chart with the release name `my-etcd`:

```bash
helm install my-etcd ./charts/etcd
```

The command deploys etcd on the Kubernetes cluster with default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-etcd` deployment:

```bash
helm uninstall my-etcd
```

This command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global Parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `replicaCount`            | Number of etcd replicas (should be odd: 1,3,5) | `3`   |
| `nameOverride`            | String to partially override etcd.name          | `""`  |
| `fullnameOverride`        | String to fully override etcd.fullname          | `""`  |

### Image Parameters

| Name                | Description                          | Value                  |
| ------------------- | ------------------------------------ | ---------------------- |
| `image.repository`  | etcd image repository                | `quay.io/coreos/etcd`  |
| `image.pullPolicy`  | etcd image pull policy               | `IfNotPresent`         |
| `image.tag`         | etcd image tag (defaults to appVersion) | `""`                |
| `imagePullSecrets`  | Image pull secrets                   | `[]`                   |

### Service Parameters

| Name                      | Description                          | Value       |
| ------------------------- | ------------------------------------ | ----------- |
| `service.type`            | Kubernetes service type              | `ClusterIP` |
| `service.clientPort`      | etcd client port                     | `2379`      |
| `service.peerPort`        | etcd peer port                       | `2380`      |
| `service.annotations`     | Service annotations                  | `{}`        |

### ServiceAccount Parameters

| Name                         | Description                                    | Value  |
| ---------------------------- | ---------------------------------------------- | ------ |
| `serviceAccount.create`      | Enable creation of ServiceAccount              | `true` |
| `serviceAccount.name`        | Name of the created serviceAccount             | `""`   |
| `serviceAccount.annotations` | ServiceAccount annotations                     | `{}`   |

### Security Parameters

| Name                                          | Description                                      | Value       |
| --------------------------------------------- | ------------------------------------------------ | ----------- |
| `podSecurityContext.fsGroup`                  | Group ID for the pod                             | `1000`      |
| `securityContext.capabilities.drop`           | Linux capabilities to drop                       | `["ALL"]`   |
| `securityContext.readOnlyRootFilesystem`      | Mount root filesystem as read-only               | `true`      |
| `securityContext.runAsNonRoot`                | Run container as non-root user                   | `true`      |
| `securityContext.runAsUser`                   | User ID for the container                        | `1000`      |

### etcd Configuration Parameters

| Name                                  | Description                                  | Value              |
| ------------------------------------- | -------------------------------------------- | ------------------ |
| `etcd.initialClusterState`            | Initial cluster state (new/existing)         | `new`              |
| `etcd.initialClusterToken`            | Initial cluster token                        | `etcd-cluster`     |
| `etcd.autoCompactionRetention`        | Auto compaction retention in hours           | `1`                |
| `etcd.autoCompactionMode`             | Auto compaction mode (periodic/revision)     | `periodic`         |
| `etcd.snapshotCount`                  | Snapshot count                               | `10000`            |
| `etcd.quotaBackendBytes`              | Quota backend bytes (8GB default)            | `8589934592`       |
| `etcd.maxRequestBytes`                | Max request bytes                            | `1572864`          |
| `etcd.heartbeatInterval`              | Heartbeat interval in milliseconds           | `100`              |
| `etcd.electionTimeout`                | Election timeout in milliseconds             | `1000`             |
| `etcd.extraEnv`                       | Additional environment variables             | `[]`               |
| `etcd.extraArgs`                      | Additional command line arguments            | `[]`               |

### Authentication Parameters

| Name                              | Description                              | Value   |
| --------------------------------- | ---------------------------------------- | ------- |
| `auth.rbac.enabled`               | Enable RBAC authentication               | `false` |
| `auth.rbac.rootPassword`          | Root user password                       | `""`    |
| `auth.rbac.existingSecret`        | Use existing secret for root password    | `""`    |
| `auth.rbac.passwordKey`           | Key in secret containing password        | `root-password` |

### Persistence Parameters

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

### Probe Parameters

| Name                                      | Description                          | Value     |
| ----------------------------------------- | ------------------------------------ | --------- |
| `livenessProbe.enabled`                   | Enable liveness probe                | `true`    |
| `livenessProbe.initialDelaySeconds`       | Initial delay seconds                | `30`      |
| `livenessProbe.periodSeconds`             | Period seconds                       | `10`      |
| `livenessProbe.timeoutSeconds`            | Timeout seconds                      | `5`       |
| `livenessProbe.failureThreshold`          | Failure threshold                    | `3`       |
| `readinessProbe.enabled`                  | Enable readiness probe               | `true`    |
| `readinessProbe.initialDelaySeconds`      | Initial delay seconds                | `10`      |
| `readinessProbe.periodSeconds`            | Period seconds                       | `5`       |
| `readinessProbe.timeoutSeconds`           | Timeout seconds                      | `3`       |
| `readinessProbe.failureThreshold`         | Failure threshold                    | `3`       |

### Other Parameters

| Name                | Description                      | Value |
| ------------------- | -------------------------------- | ----- |
| `podAnnotations`    | Pod annotations                  | `{}`  |
| `nodeSelector`      | Node labels for pod assignment   | `{}`  |
| `tolerations`       | Tolerations for pod assignment   | `[]`  |
| `affinity`          | Affinity for pod assignment      | `{}`  |
| `extraVolumes`      | Additional volumes               | `[]`  |
| `extraVolumeMounts` | Additional volume mounts         | `[]`  |

## Configuration Examples

### Single Node Cluster

```yaml
replicaCount: 1
```

### Three Node Cluster with Custom Resources

```yaml
replicaCount: 3
resources:
  limits:
    cpu: 1000m
    memory: 1Gi
  requests:
    cpu: 200m
    memory: 256Mi
```

### Enable RBAC Authentication

```yaml
auth:
  rbac:
    enabled: true
    rootPassword: "your-secure-password"
```

### Custom Storage Class

```yaml
persistence:
  enabled: true
  storageClass: "fast-ssd"
  size: 16Gi
```

## Accessing etcd

After installation, you can access etcd using the service:

```bash
# Get the service name
kubectl get svc -l app.kubernetes.io/name=etcd

# Connect using etcdctl from a pod
kubectl run etcd-client --rm -it --restart=Never \
  --image=quay.io/coreos/etcd:v3.5.17 \
  --env ETCDCTL_API=3 \
  --command -- /bin/sh

# Inside the pod
etcdctl --endpoints=http://my-etcd.default.svc.cluster.local:2379 put mykey "Hello etcd"
etcdctl --endpoints=http://my-etcd.default.svc.cluster.local:2379 get mykey
```

## Upgrading

To upgrade the chart:

```bash
helm upgrade my-etcd ./charts/etcd
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
