{{- define "appName" -}}
  {{ .Release.Name }}
{{- end }}

{{- define "jobName" -}}
  {{- if .Values.jobNameOverride -}}
    {{ .Values.jobNameOverride }}
  {{- else -}}
    {{ include "appName" . }}-{{ .Chart.Version | replace "+" "_" }}
  {{- end -}}
{{- end }}
