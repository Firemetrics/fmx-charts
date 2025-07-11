{{- define "appName" -}}
  {{ .Release.Name }}
{{- end }}

{{- define "resourceReaderSaName" -}}
  {{ .Release.Name }}-resource-reader
{{- end }}

{{- define "registry.secretName" -}}
  {{ .Release.Name }}-registry
{{- end }}

{{- define "ingress.publicUrl" -}}
  https://{{ .Values.ingress.host }}
{{- end }}

{{- define "spilo.podLabel" -}}
  {{ .Release.Name }}-spilo
{{- end }}

{{- define "spilo.svcName" -}}
  {{ .Release.Name }}-spilo
{{- end }}

{{- define "spilo.pvcName" -}}
  {{ .Release.Name }}-spilo-data
{{- end }}

{{- define "spilo.bootstrapJob" -}}
  {{ .Release.Name }}-spilo-bootstrap
{{- end }}

{{- define "db.hostname" }}
  {{- if .Values.provision.spilo.enabled -}}
    {{ include "spilo.svcName" . }}
  {{- else -}}
    {{ .Values.database.externalHostname }}
  {{- end }}
{{- end }}

{{- define "db.databaseUrl" -}}
  {{ printf "postgresql://%s:%s@%s:%d/%s" .Values.database.username .Values.database.password (include "db.hostname" .) (.Values.database.port | int) .Values.database.dbname }}
{{- end }}

{{- define "oidc.discoveryUrl" }}
  {{- if and .Values.ingress.enabled .Values.provision.keycloak.enabled .Values.provision.keycloak.importRealm.enabled -}}
    {{ include "ingress.publicUrl" . }}{{ .Values.provision.keycloak.publicPath }}/realms/{{ .Values.provision.keycloak.importRealm.realmName }}/.well-known/openid-configuration
  {{- else }}
    {{- .Values.oidc.externalDiscoveryUrl }}
  {{- end }}
{{- end }}

{{- define "panel.podLabel" -}}
  {{ .Release.Name }}-panel
{{- end }}

{{- define "panel.svcName" -}}
  {{ .Release.Name }}-panel
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

{{- define "fuego.oidcAudience" -}}
  {{ include "fuego.publicUrl" . }}/fhir/
{{- end }}

{{- define "fhir.baseUrl" -}}
  {{ include "fuego.publicUrl" . }}/fhir
{{- end }}
