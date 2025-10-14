{{- define "appName" -}}
  {{ .Release.Name }}
{{- end }}

{{- define "podLabel" -}}
  {{ .Release.Name }}
{{- end }}

{{- define "svcName" -}}
  {{ .Release.Name }}
{{- end }}

{{- define "receiverAppName" -}}
  {{ include "appName" . }}-receiver
{{- end }}

{{- define "receiverPodLabel" -}}
  {{ include "appName" . }}-receiver
{{- end }}

{{- define "receiverSvcName" -}}
  {{ include "appName" . }}-receiver
{{- end }}
