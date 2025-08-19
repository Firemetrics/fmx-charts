{{- define "appName" -}}
  {{ .Release.Name }}
{{- end }}

{{- define "importRealmConfigMapName" -}}
  {{ include "appName" . }}-import-realm
{{- end }}

{{- define "podLabel" -}}
  {{ include "appName" . }}
{{- end -}}

{{- define "svcName" -}}
  {{- if .Values.service.nameOverride -}}
    {{ .Values.service.nameOverride }}
  {{- else -}}
    {{ include "appName" . }}
  {{- end -}}
{{- end -}}

{{- define "podHttpPort" -}}
  8080
{{- end }}
