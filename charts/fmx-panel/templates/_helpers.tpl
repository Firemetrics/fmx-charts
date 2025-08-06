{{- define "appName" -}}
  {{ .Release.Name }}
{{- end }}

{{- define "podLabel" -}}
  {{ .Release.Name }}
{{- end }}

{{- define "svcName" -}}
  {{ .Release.Name }}
{{- end }}

{{- define "oidcAudience" -}}
  {{- if .Values.oidc.audience -}}
    {{ .Values.oidc.audience }}
  {{- else -}}
    {{ .Values.publicUrl }}/
  {{- end }}
{{- end }}
