{{- define "appName" -}}
  {{ .Release.Name }}
{{- end -}}

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

{{- define "hapiAppName" -}}
  {{ include "appName" . }}-hapi
{{- end -}}

{{- define "hapiPodLabel" -}}
  {{ include "hapiAppName" . }}
{{- end -}}

{{- define "hapiSvcName" -}}
  {{- if .Values.hapi.service.nameOverride -}}
    {{ .Values.hapi.service.nameOverride }}
  {{- else -}}
    {{ include "hapiAppName" . }}
  {{- end -}}
{{- end -}}
