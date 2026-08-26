{{- define "appName" -}}
  {{ .Release.Name }}
{{- end }}

{{/*
Whether the Alloy collector is deployed at all: it hosts both the metrics
and the logs pipeline, so either one keeps it alive.
*/}}
{{- define "alloyEnabled" -}}
  {{- if or .Values.metrics.enabled .Values.logs.enabled -}}
    true
  {{- end -}}
{{- end }}

{{/* Alloy helpers */}}
{{- define "alloyAppName" -}}
  {{ include "appName" . }}-alloy
{{- end }}

{{- define "alloyPodLabel" -}}
  {{ include "alloyAppName" . }}
{{- end }}

{{- define "alloyConfigMapName" -}}
  {{ include "alloyAppName" . }}-config
{{- end }}

{{- define "alloyServiceAccountName" -}}
  {{ include "alloyAppName" . }}
{{- end }}

{{/*
Cluster-scoped RBAC objects carry the release namespace in their name so two
releases in different namespaces cannot collide.
*/}}
{{- define "alloyClusterRoleName" -}}
  {{ include "alloyAppName" . }}-{{ .Release.Namespace }}
{{- end }}

{{/* Prometheus helpers */}}
{{- define "prometheusAppName" -}}
  {{ include "appName" . }}-prometheus
{{- end }}

{{- define "prometheusPodLabel" -}}
  {{ include "prometheusAppName" . }}
{{- end }}

{{- define "prometheusSvcName" -}}
  {{ include "prometheusAppName" . }}
{{- end }}

{{- define "prometheusConfigMapName" -}}
  {{ include "prometheusAppName" . }}-config
{{- end }}

{{- define "prometheusPvcName" -}}
  {{ include "prometheusAppName" . }}-data
{{- end }}

{{- define "prometheusPodHttpPort" -}}
  9090
{{- end }}

{{/* kube-state-metrics helpers */}}
{{- define "ksmAppName" -}}
  {{ include "appName" . }}-kube-state-metrics
{{- end }}

{{- define "ksmPodLabel" -}}
  {{ include "ksmAppName" . }}
{{- end }}

{{- define "ksmSvcName" -}}
  {{ include "ksmAppName" . }}
{{- end }}

{{- define "ksmServiceAccountName" -}}
  {{ include "ksmAppName" . }}
{{- end }}

{{- define "ksmClusterRoleName" -}}
  {{ include "ksmAppName" . }}-{{ .Release.Namespace }}
{{- end }}

{{- define "ksmPodHttpPort" -}}
  8080
{{- end }}
