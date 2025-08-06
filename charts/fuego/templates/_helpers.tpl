{{- define "appName" -}}
  {{ .Release.Name }}
{{- end -}}

{{- define "podLabel" -}}
  {{ include "appName" . }}
{{- end }}

{{- define "svcName" -}}
  {{- if .Values.service.nameOverride -}}
    {{ .Values.service.nameOverride }}
  {{- else -}}
    {{ include "appName" . }}
  {{- end -}}
{{- end }}
