# Flower Helm Chart

A Helm chart for deploying [Celery Flower](https://github.com/mher/flower) - a real-time web-based monitoring tool for Celery.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- A running Celery broker (Redis, RabbitMQ, etc.)

## Installing the Chart

### Basic Installation

```bash
helm install my-flower ./flower \
  --set celery.brokerUrl="redis://redis:6379/0"
```

### Installation with Custom Values

```bash
helm install my-flower ./flower -f custom-values.yaml
```

## Configuration

### Required Configuration

You **must** configure the Celery broker URL using one of these methods:

**Option 1: Direct URL**
```yaml
celery:
  brokerUrl: "redis://redis:6379/0"
```

**Option 2: Existing Secret**
```yaml
celery:
  brokerUrlSecretName: "my-broker-secret"
  brokerUrlSecretKey: "broker-url"
```

### Common Configuration Examples

#### Enable Ingress

```yaml
ingress:
  enabled: true
  className: nginx
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
  hosts:
    - host: flower.example.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: flower-tls
      hosts:
        - flower.example.com
```

#### Enable Basic Authentication

```yaml
flower:
  basicAuth:
    enabled: true
    username: admin
    password: secretpassword
```

#### Enable Persistence

```yaml
persistence:
  enabled: true
  size: 5Gi
  storageClass: standard
```

#### Configure Resources

```yaml
resources:
  limits:
    cpu: 1000m
    memory: 1Gi
  requests:
    cpu: 200m
    memory: 256Mi
```

### All Configuration Options

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of Flower replicas | `1` |
| `image.repository` | Flower image repository | `mher/flower` |
| `image.tag` | Flower image tag | `""` (uses appVersion) |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `serviceAccount.create` | Create service account | `true` |
| `service.type` | Kubernetes service type | `ClusterIP` |
| `service.port` | Service port | `5555` |
| `ingress.enabled` | Enable ingress | `false` |
| `ingress.className` | Ingress class name | `""` |
| `celery.brokerUrl` | Celery broker URL | `""` |
| `celery.brokerUrlSecretName` | Secret containing broker URL | `""` |
| `flower.basicAuth.enabled` | Enable basic authentication | `false` |
| `flower.basicAuth.username` | Basic auth username | `""` |
| `flower.basicAuth.password` | Basic auth password | `""` |
| `flower.persistent` | Enable persistent mode | `false` |
| `flower.dbFile` | Database file path | `/data/flower.db` |
| `flower.maxTasks` | Max tasks to keep in memory | `10000` |
| `flower.port` | Flower port | `5555` |
| `persistence.enabled` | Enable persistence | `false` |
| `persistence.size` | PVC size | `1Gi` |
| `persistence.storageClass` | Storage class | `""` |
| `resources.limits.cpu` | CPU limit | `500m` |
| `resources.limits.memory` | Memory limit | `512Mi` |
| `resources.requests.cpu` | CPU request | `100m` |
| `resources.requests.memory` | Memory request | `128Mi` |

## Examples

### Redis Broker

```bash
helm install flower ./flower \
  --set celery.brokerUrl="redis://redis-master:6379/0"
```

### RabbitMQ Broker

```bash
helm install flower ./flower \
  --set celery.brokerUrl="amqp://user:password@rabbitmq:5672//"
```

### With Authentication and Ingress

```yaml
# values.yaml
celery:
  brokerUrl: "redis://redis:6379/0"

flower:
  basicAuth:
    enabled: true
    username: admin
    password: changeme

ingress:
  enabled: true
  className: nginx
  hosts:
    - host: flower.local
      paths:
        - path: /
          pathType: Prefix
```

```bash
helm install flower ./flower -f values.yaml
```

### Production Setup with Persistence

```yaml
# production-values.yaml
replicaCount: 2

celery:
  brokerUrlSecretName: celery-broker-secret
  brokerUrlSecretKey: url

flower:
  basicAuth:
    enabled: true
    existingSecret: flower-auth-secret
  persistent: true
  maxTasks: 50000

persistence:
  enabled: true
  size: 10Gi
  storageClass: fast-ssd

resources:
  limits:
    cpu: 2000m
    memory: 2Gi
  requests:
    cpu: 500m
    memory: 512Mi

ingress:
  enabled: true
  className: nginx
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
  hosts:
    - host: flower.example.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: flower-tls
      hosts:
        - flower.example.com
```

```bash
helm install flower ./flower -f production-values.yaml
```

> [!NOTE]
> When `flower.urlPrefix` is configured, health check probe paths are
> automatically prefixed. For example, with `urlPrefix: /flower`, the
> probe path becomes `/flower/healthcheck` instead of `/healthcheck`.

## Upgrading

```bash
helm upgrade flower ./flower -f values.yaml
```

## Uninstalling

```bash
helm uninstall flower
```

## Security Considerations

1. **Always enable basic authentication** in production environments
2. **Use TLS/HTTPS** when exposing Flower externally
3. **Store sensitive data in Kubernetes secrets**, not in values files
4. **Enable security contexts** (enabled by default)
5. **Use read-only root filesystem** (enabled by default)

## Troubleshooting

### Flower can't connect to broker

Check the broker URL configuration:
```bash
kubectl logs -l app.kubernetes.io/name=flower
```

### Authentication not working

Verify the secret is created correctly:
```bash
kubectl get secret flower-auth -o yaml
```

### Persistence issues

Check PVC status:
```bash
kubectl get pvc
kubectl describe pvc flower
```

## License

This Helm chart is licensed under the terms described in the LICENSE file in the repository.
