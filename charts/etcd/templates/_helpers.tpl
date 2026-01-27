{{/*
Expand the name of the chart.
*/}}
{{- define "etcd.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "etcd.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "etcd.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "etcd.labels" -}}
helm.sh/chart: {{ include "etcd.chart" . }}
{{ include "etcd.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "etcd.selectorLabels" -}}
app.kubernetes.io/name: {{ include "etcd.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "etcd.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "etcd.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Get the image tag
*/}}
{{- define "etcd.imageTag" -}}
{{- .Values.image.tag | default .Chart.AppVersion }}
{{- end }}

{{/*
Validate replica count
*/}}
{{- define "etcd.validateReplicaCount" -}}
{{- if lt (int .Values.replicaCount) 1 }}
{{- fail "replicaCount must be at least 1" }}
{{- end }}
{{- if eq (mod (int .Values.replicaCount) 2) 0 }}
{{- if gt (int .Values.replicaCount) 1 }}
{{- fail "replicaCount should be an odd number (1, 3, 5, etc.) for proper quorum. Even numbers can lead to split-brain scenarios." }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Validate authentication configuration
*/}}
{{- define "etcd.validateAuth" -}}
{{- if .Values.auth.rbac.enabled }}
{{- if not .Values.auth.rbac.existingSecret }}
{{- if not .Values.auth.rbac.rootPassword }}
{{- fail "When auth.rbac.enabled is true and auth.rbac.existingSecret is not set, auth.rbac.rootPassword must be provided" }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Generate initial cluster members
*/}}
{{- define "etcd.initialCluster" -}}
{{- $fullname := include "etcd.fullname" . -}}
{{- $namespace := .Release.Namespace -}}
{{- $peerPort := .Values.service.peerPort -}}
{{- $replicaCount := int .Values.replicaCount -}}
{{- $members := list -}}
{{- range $i := until $replicaCount -}}
{{- $members = append $members (printf "%s-%d=http://%s-%d.%s-headless.%s.svc.cluster.local:%d" $fullname $i $fullname $i $fullname $namespace (int $peerPort)) -}}
{{- end -}}
{{- join "," $members -}}
{{- end }}
