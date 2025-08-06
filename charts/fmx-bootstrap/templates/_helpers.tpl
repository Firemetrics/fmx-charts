{{- define "appName" -}}
  {{ .Release.Name }}
{{- end }}

{{- define "jobName" -}}
  {{- if .Values.jobNameOverride -}}
    {{ .Values.jobNameOverride }}
  {{- else -}}
    {{ include "appName" . }}
  {{- end -}}
{{- end }}
