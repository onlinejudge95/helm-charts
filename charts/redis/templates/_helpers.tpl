{{/*
Validate architecture value
*/}}
{{- define "redis.validateArchitecture" -}}
{{- $validArchitectures := list "standalone" "sentinel" -}}
{{- if not (has .Values.architecture $validArchitectures) -}}
{{- fail (printf "Invalid architecture '%s'. Must be one of: %s" .Values.architecture (join ", " $validArchitectures)) -}}
{{- end -}}
{{- end -}}

{{/*
Expand the name of the chart.
*/}}
{{- define "redis.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "redis.fullname" -}}
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
{{- define "redis.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "redis.labels" -}}
helm.sh/chart: {{ include "redis.chart" . }}
{{ include "redis.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "redis.selectorLabels" -}}
app.kubernetes.io/name: {{ include "redis.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Sentinel labels
*/}}
{{- define "redis.sentinelLabels" -}}
helm.sh/chart: {{ include "redis.chart" . }}
{{ include "redis.sentinelSelectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Sentinel selector labels
*/}}
{{- define "redis.sentinelSelectorLabels" -}}
app.kubernetes.io/name: {{ include "redis.name" . }}-sentinel
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "redis.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "redis.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the proper Redis image name
*/}}
{{- define "redis.image" -}}
{{- $tag := .Values.image.tag | default .Chart.AppVersion -}}
{{- printf "%s:%s" .Values.image.repository $tag -}}
{{- end }}

{{/*
Return Redis password
*/}}
{{- define "redis.password" -}}
{{- if .Values.auth.existingSecret }}
{{- printf "%s" .Values.auth.existingSecret }}
{{- else }}
{{- printf "%s-auth" (include "redis.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Return the master service name
*/}}
{{- define "redis.masterService" -}}
{{- printf "%s-master" (include "redis.fullname" .) -}}
{{- end }}

{{/*
Return the headless service name
*/}}
{{- define "redis.headlessService" -}}
{{- printf "%s-headless" (include "redis.fullname" .) -}}
{{- end }}

{{/*
Return the sentinel service name
*/}}
{{- define "redis.sentinelService" -}}
{{- printf "%s-sentinel" (include "redis.fullname" .) -}}
{{- end }}

{{/*
Return the master name for sentinel
*/}}
{{- define "redis.masterName" -}}
{{- printf "%s-master" (include "redis.fullname" .) -}}
{{- end }}
