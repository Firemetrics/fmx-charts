{{- define "appName" -}}
  {{ .Release.Name }}
{{- end -}}

{{- define "postgresAppName" -}}
  {{ include "appName" . }}-postgres
{{- end -}}

{{- define "bootstrapAppName" -}}
  {{ include "appName" . }}-bootstrap
{{- end -}}

{{- define "fuegoAppName" -}}
  {{ include "appName" . }}-fuego
{{- end -}}

{{- define "panelAppName" -}}
  {{ include "appName" . }}-panel
{{- end -}}

{{- define "keycloakAppName" -}}
  {{ include "appName" . }}-keycloak
{{- end -}}

{{- define "ingressAppName" -}}
  {{ include "appName" . }}-ingress
{{- end -}}

{{- define "minioAppName" -}}
  {{ include "appName" . }}-minio
{{- end -}}

{{- define "databaseHostname" -}}
  {{- if .Values.database.hostnameOverride -}}
    {{ .Values.database.hostnameOverride }}
  {{- else -}}
    {{ include "postgresAppName" . }}
  {{- end -}}
{{- end -}}

{{- define "httpScheme" -}}
  {{- if .Values.tls.enabled -}}
    https
  {{- else -}}
    http
  {{- end -}}
{{- end -}}

{{- define "baseUrl" -}}
  {{ include "httpScheme" . }}://{{ .Values.hostname }}
{{- end -}}

{{- define "panelUrl" -}}
  {{ include "baseUrl" . }}{{ .Values.components.panel.publicPath }}
{{- end -}}

{{- define "panelOidcAudience" -}}
  {{- if .Values.components.panel.oidc.audience -}}
    {{ .Values.components.panel.oidc.audience }}
  {{- else -}}
    {{ include "panelUrl" . }}/
  {{- end }}
{{- end }}

{{- define "fuegoUrl" -}}
  {{ include "baseUrl" . }}
{{- end -}}

{{- define "fhirPath" -}}
  /fhir
{{- end -}}

{{- define "fhirBaseUrl" -}}
  {{ include "fuegoUrl" . }}{{ include "fhirPath" . }}
{{- end -}}

{{- define "keycloakPublicUrl" -}}
  {{ include "baseUrl" . }}{{ .Values.components.keycloak.publicPath }}
{{- end -}}

{{- define "databaseSuperUserSecretName" -}}
  {{- if .Values.database.existingSuperUserSecret -}}
    {{ .Values.database.existingSuperUserSecret }}
  {{- else -}}
    {{ .Values.database.superUserName }}.{{ include "databaseHostname" . }}.credentials.postgresql.acid.zalan.do
  {{- end -}}
{{- end -}}

{{- define "oidcDiscoveryUrl" }}
  {{- if .Values.oidc.discoveryUrlOverride -}}
    {{ .Values.oidc.discoveryUrlOverride }}
  {{- else -}}
    {{ include "keycloakPublicUrl" . }}/realms/{{ .Values.oidc.keycloakRealm }}/.well-known/openid-configuration
  {{- end -}}
{{- end -}}

{{- define "fuegoOidcAudience" -}}
  {{ include "fuegoUrl" . }}{{ include "fhirPath" . }}/
{{- end -}}

{{- define "internalFuegoUrl" -}}
  http://{{ include "fuegoAppName" . }}.{{ .Release.Namespace }}.svc.cluster.local
{{- end -}}

{{- define "internalFhirBaseUrl" -}}
  {{ include "internalFuegoUrl" . }}{{ include "fhirPath" . }}
{{- end -}}

{{- define "backupTargetSecretName" -}}
  {{ include "appName" . }}-backup-target
{{- end -}}

{{- define "tlsCertSecretName" -}}
  {{- if .Values.tls.certSecret.nameOverride -}}
    {{ .Values.tls.certSecret.nameOverride }}
  {{- else -}}
    {{ include "appName" . }}-tls-cert
  {{- end -}}
{{- end -}}

{{- define "caCertsConfigMapName" -}}
  {{- if .Values.caCertsConfigMap.nameOverride -}}
    {{ .Values.caCertsConfigMap.nameOverride }}
  {{- else -}}
    {{ include "appName" . }}-ca-certs
  {{- end -}}
{{- end -}}
