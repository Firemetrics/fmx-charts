{{- define "appName" -}}
  {{ .Release.Name }}
{{- end }}

{{- define "childAppName" -}}
  {{- if .Values.application.nameOverride -}}
    {{ .Values.application.nameOverride }}
  {{- else -}}
    {{ include "appName" . }}-child
  {{- end -}}
{{- end }}

{{- define "importRealmConfigMapName" -}}
  {{ include "appName" . }}-import-realm
{{- end }}

{{- define "dataPvcName" -}}
  {{ include "appName" . }}-data
{{- end }}

{{- define "panel.publicUrl" -}}
  {{- if and .Values.ingress.enabled .Values.provision.panel.enabled -}}
    {{ include "ingress.publicUrl" . }}{{ .Values.provision.panel.publicPath }}
  {{- else -}}
    {{ .Values.panel.externalUrl }}
  {{- end }}
{{- end }}

{{- define "panel.oidcAudience" -}}
  {{- if .Values.panel.oidc.audience -}}
    {{ .Values.panel.oidc.audience }}
  {{- else -}}
    {{ include "panel.publicUrl" . }}/
  {{- end }}
{{- end }}

{{- define "fuego.podLabel" -}}
  {{ .Release.Name }}-fuego
{{- end }}

{{- define "fuego.svcName" -}}
  {{ .Release.Name }}-fuego
{{- end }}

{{- define "fuego.publicUrl" -}}
  {{- if and .Values.ingress.enabled .Values.provision.fuego.enabled -}}
    {{ include "ingress.publicUrl" . }}
  {{- else -}}
    {{ .Values.fuego.externalUrl }}
  {{- end }}
{{- end }}

{{- define "fuego.clusterUrl" -}}
  {{- if .Values.provision.fuego.enabled -}}
    http://{{ include "fuego.svcName" . }}.{{ .Release.Namespace }}.svc.cluster.local
  {{- else -}}
    {{ .Values.fuego.externalUrl }}
  {{- end }}
{{- end }}

{{- define "fuego.oidcAudience" -}}
  {{ include "fuego.publicUrl" . }}/fhir/
{{- end }}

{{- define "fhir.clusterBaseUrl" -}}
  {{ include "fuego.clusterUrl" . }}/fhir
{{- end }}
