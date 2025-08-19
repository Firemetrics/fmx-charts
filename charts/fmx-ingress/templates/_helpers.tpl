{{- define "appName" -}}
  {{ .Release.Name }}
{{- end -}}

{{- define "httpScheme" -}}
  {{- if .Values.tls.enabled -}}
    https
  {{- else -}}
    http
  {{- end -}}
{{- end -}}

{{- define "defaultPath" -}}
  {{- if .Values.services.panel.enabled -}}
    {{ .Values.services.panel.path }}
  {{- else if .Values.services.keycloak.enabled -}}
    {{ .Values.services.keycloak.path }}
  {{- else if .Values.services.fuego.enabled -}}
    {{ .Values.services.fuego.path }}
  {{- end }}
{{- end -}}
