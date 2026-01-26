{{/*
Expand the name of the chart.
*/}}
{{- define "flower.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "flower.fullname" -}}
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
{{- define "flower.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "flower.labels" -}}
helm.sh/chart: {{ include "flower.chart" . }}
{{ include "flower.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "flower.selectorLabels" -}}
app.kubernetes.io/name: {{ include "flower.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "flower.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "flower.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Get the image tag
*/}}
{{- define "flower.imageTag" -}}
{{- .Values.image.tag | default .Chart.AppVersion }}
{{- end }}

{{/*
Validate basic auth configuration
*/}}
{{- define "flower.validateBasicAuth" -}}
{{- if .Values.flower.basicAuth.enabled }}
{{- if not .Values.flower.basicAuth.existingSecret }}
{{- if or (not .Values.flower.basicAuth.username) (not .Values.flower.basicAuth.password) }}
{{- fail "When flower.basicAuth.enabled is true and flower.basicAuth.existingSecret is not set, both flower.basicAuth.username and flower.basicAuth.password must be provided" }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Get probe path with urlPrefix if configured
*/}}
{{- define "flower.probePath" -}}
{{- if .Values.flower.urlPrefix -}}
{{- printf "%s%s" .Values.flower.urlPrefix .path -}}
{{- else -}}
{{- .path -}}
{{- end -}}
{{- end }}
