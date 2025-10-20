{{- define "appName" -}}
  {{ .Release.Name }}
{{- end }}

{{- define "receiverAppName" -}}
  {{ include "appName" . }}-receiver
{{- end }}

{{- define "receiverPodLabel" -}}
  {{ include "receiverAppName" . }}
{{- end }}

{{- define "receiverSvcName" -}}
  {{ include "receiverAppName" . }}
{{- end }}

{{- define "webContainerPort" -}}
  8080
{{- end }}

{{- define "webAppName" -}}
  {{ include "appName" . }}-web
{{- end }}

{{- define "webPodLabel" -}}
  {{ include "webAppName" . }}
{{- end }}

{{- define "webSvcName" -}}
  {{ include "webAppName" . }}
{{- end }}

{{- define "webConfigMapName" -}}
  {{ include "appName" . }}-web-config
{{- end }}

{{- define "s3AccessKeyEnvName" -}}
  S3_ACCESS_KEY
{{- end }}

{{- define "s3SecretKeyEnvName" -}}
  S3_SECRET_KEY
{{- end }}
