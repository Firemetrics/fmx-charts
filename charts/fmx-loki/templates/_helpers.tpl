{{- define "appName" -}}
  {{ .Release.Name }}
{{- end }}

{{/* Loki helpers */}}
{{- define "lokiAppName" -}}
  {{ include "appName" . }}-loki
{{- end }}

{{- define "lokiPodLabel" -}}
  {{ include "lokiAppName" . }}
{{- end }}

{{- define "lokiSvcName" -}}
  {{- if .Values.service.nameOverride -}}
    {{ .Values.service.nameOverride }}
  {{- else -}}
    {{ include "lokiAppName" . }}
  {{- end -}}
{{- end }}

{{- define "lokiConfigMapName" -}}
  {{ include "lokiAppName" . }}-config
{{- end }}

{{- define "lokiPvcName" -}}
  {{ include "lokiAppName" . }}-data
{{- end }}

{{- define "lokiHttpPort" -}}
  3100
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

{{- define "alloyClusterRoleName" -}}
  {{ include "alloyAppName" . }}
{{- end }}
