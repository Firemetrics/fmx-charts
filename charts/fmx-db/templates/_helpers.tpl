{{- define "appName" -}}
  {{ .Release.Name }}
{{- end }}

{{- define "registry.secretName" -}}
  {{- if .Values.registryAuth.existingSecret -}}
    {{ .Values.registryAuth.existingSecret }}
  {{- else -}}
    {{ .Release.Name }}-registry
  {{- end -}}
{{- end }}

