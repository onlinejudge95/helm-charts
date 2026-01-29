# Etcd Helm Chart

A highly configurable Helm chart for deploying an Etcd cluster in Kubernetes with support for High Availability (HA).

## Features

- **High Availability**: Supports 3+ node clusters with Raft consensus.
- **Dynamic Bootstrapping**: Automatically constructs the initial cluster connection string.
- **Architecture Modes**: Switch between `standalone` (single node) and `ha` (multi-node) easily.
- **Persistence**: StatefulSet-based storage management.

## Installation

```bash
helm install etcd ./charts/etcd
```

## Architecture Configuration

### High Availability (Default)

The default configuration deploys a 3-node HA cluster.

```yaml
architecture: ha
replicaCount: 3
```

### Standalone

For development or testing, you can deploy a single-node Etcd instance.

```yaml
architecture: standalone
replicaCount: 1
```

## Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `architecture` | Cluster mode: `ha` or `standalone` | `ha` |
| `replicaCount` | Number of replicas (for HA mode) | `3` |
| `image.repository` | Etcd image repository | `registry.k8s.io/etcd` |
| `image.tag` | Etcd image tag | `3.5.10-0` |
| `etcd.dataDir` | Directory for data storage | `/var/run/etcd/default.etcd` |
| `etcd.initialClusterState` | 'new' or 'existing' | `new` |
| `auth.rbac.enabled` | Enable RBAC and Auth Bootstrapping | `true` |
| `auth.rbac.create` | Auto-create root user | `true` |
| `auth.rbac.rootPassword` | Root user password | `etcd-root-password` |
| `ingress.enabled` | Enable Ingress resource | `false` |
| `ingress.hosts` | List of Ingress hosts | `[{"host": "chart-example.local", "paths": [...]}]` |
| `ingress.tls` | Ingress TLS configuration | `[]` |
| `persistence.enabled` | Enable persistent storage | `true` |
| `persistence.size` | Size of persistent volume | `8Gi` |
| `resources` | CPU/Memory resource requests/limits | `{}` |

## Headless Service

The chart creates a Headless Service (`<release-name>-headless`) to manage internal peer discovery and consistent network identities for the StatefulSet pods.

## Version Compatibility

The Authentication Bootstrap Job uses `alpine:3.19` to provide a shell environment, installing the `etcd` package from Alpine's repositories. There is a potential risk that the version of `etcdctl` in Alpine may differ slightly from the Etcd version running in the cluster (`registry.k8s.io/etcd`). While usually compatible, please be aware of this potential version mismatch.
