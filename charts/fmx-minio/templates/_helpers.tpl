{{- define "appName" -}}
  {{ .Release.Name }}
{{- end }}

{{- define "childAppName" -}}
  {{- if .Values.application.nameOverride -}}
    {{ .Values.application.nameOverride }}
  {{- else -}}
    {{ include "appName" . }}-tenant
  {{- end -}}
{{- end }}

{{- define "tenantName" -}}
  {{- if .Values.tenantNameOverride -}}
    {{ .Values.tenantNameOverride }}
  {{- else -}}
    {{ include "appName" . }}
  {{- end -}}
{{- end }}

{{- define "configSecretName" -}}
  {{- if .Values.configSecret.nameOverride -}}
    {{ .Values.configSecret.nameOverride }}
  {{- else -}}
    {{ include "appName" . }}
  {{- end -}}
{{- end }}

