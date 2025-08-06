{{- define "appName" -}}
  {{ .Release.Name }}
{{- end -}}

{{- define "clusterName" -}}
  {{- if .Values.clusterNameOverride -}}
    {{ .Values.clusterNameOverride }}
  {{- else -}}
    {{ include "appName" . }}
  {{- end -}}
{{- end -}}
