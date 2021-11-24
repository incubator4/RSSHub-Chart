{{/*
Expand the name of the chart.
*/}}
{{- define "rss-hub.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "rss-hub.fullname" -}}
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
{{- define "rss-hub.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "rss-hub.labels" -}}
helm.sh/chart: {{ include "rss-hub.chart" . }}
{{ include "rss-hub.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "rss-hub.selectorLabels" -}}
app.kubernetes.io/name: {{ include "rss-hub.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "rss-hub.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "rss-hub.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create redis name and version as used by the chart label.
*/}}
{{- define "rss-hub.redis.fullname" -}}
{{- $redisHa := (index .Values "redis-ha") -}}
{{- $redisHaContext := dict "Chart" (dict "Name" "redis-ha") "Release" .Release "Values" $redisHa -}}
{{- if $redisHa.enabled -}}
    {{- if $redisHa.haproxy.enabled -}}
        {{- printf "%s-haproxy" (include "redis-ha.fullname" $redisHaContext) | trunc 63 | trimSuffix "-" -}}
    {{- end -}}
{{- else -}}
{{- printf "%s-%s" (include "rss-hub.fullname" .) .Values.redis.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the redis service account to use
*/}}
{{- define "rss-hub.redisServiceAccountName" -}}
{{- if .Values.redis.serviceAccount.create -}}
    {{ default (include "rss-hub.redis.fullname" .) .Values.redis.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.redis.serviceAccount.name }}
{{- end -}}
{{- end -}}