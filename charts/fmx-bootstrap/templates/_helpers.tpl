{{- define "appName" -}}
  {{ .Release.Name }}
{{- end }}

{{- define "jobName" -}}
  {{- if .Values.jobNameOverride -}}
    {{ .Values.jobNameOverride }}
  {{- else -}}
    {{ include "appName" . }}-{{ .Release.Revision }}
  {{- end -}}
{{- end }}
