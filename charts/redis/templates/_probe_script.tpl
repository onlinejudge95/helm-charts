{{- define "redis.probeScript" -}}
#!/bin/sh
set -e

# Build the redis-cli command based on environment and config
CMD="redis-cli"

# TLS Configuration
if [ "$TLS_ENABLED" = "true" ]; then
    CMD="$CMD --tls"
    
    # Insecure mode (skip verification)
    if [ "$TLS_INSECURE" = "true" ]; then
        CMD="$CMD --insecure"
    fi

    # Client Certificate (only if Auth Clients enabled)
    if [ "$TLS_AUTH_CLIENTS" = "true" ]; then
        CMD="$CMD --cert /certs/$TLS_CERT_FILENAME --key /certs/$TLS_KEY_FILENAME"
    fi

    # CA Certificate (only if filename provided)
    if [ -n "$TLS_CA_CERT_FILENAME" ]; then
        CMD="$CMD --cacert /certs/$TLS_CA_CERT_FILENAME"
    fi
fi

# Authenticate if password is set
if [ -n "$REDIS_PASSWORD" ]; then
    CMD="$CMD -a $REDIS_PASSWORD"
fi

# Execute ping
exec $CMD ping
{{- end -}}
