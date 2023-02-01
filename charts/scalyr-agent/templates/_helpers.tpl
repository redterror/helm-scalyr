{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "scalyr-helm.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "scalyr-helm.fullname" -}}
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
User-overrideable name for the serviceAccount
*/}}
{{- define "scalyr-helm.serviceAccountName" -}}
{{- if .Values.serviceAccount.nameOverride }}
{{- .Values.serviceAccount.nameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- include "scalyr-helm.fullname" . }}-sa
{{- end}}
{{- end}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "scalyr-helm.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "scalyr-helm.labels" -}}
helm.sh/chart: {{ include "scalyr-helm.chart" . }}
{{ include "scalyr-helm.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Non agent template (kube-state-metrics, node-exporter) labels
*/}}
{{- define "scalyr-helm.dependencies-labels" -}}
helm.sh/chart: {{ include "scalyr-helm.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "scalyr-helm.selectorLabels" -}}
app.kubernetes.io/name: {{ include "scalyr-helm.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Arbitrary Optional User Defined Pod labels
*/}}
{{- define "scalyr-helm.podLabels" -}}
{{- with .Values.podLabels }}
{{- toYaml . }}
{{- end }}
{{- end }}
