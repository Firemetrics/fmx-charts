{{- define "appName" -}}
  {{ .Release.Name }}
{{- end }}

{{- define "registry.secretName" -}}
  {{ .Release.Name }}-registry
{{- end }}

