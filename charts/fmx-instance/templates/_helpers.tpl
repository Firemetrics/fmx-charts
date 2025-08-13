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

{{- define "keycloakChildAppName" -}}
  {{ include "keycloakAppName" . }}-child
{{- end -}}

{{- define "ingressAppName" -}}
  {{ include "appName" . }}-ingress
{{- end -}}

{{- define "minioAppName" -}}
  {{ include "appName" . }}-minio
{{- end -}}

{{- define "postgresClusterName" -}}
  {{- if .Values.components.postgres.clusterNameOverride -}}
    {{ .Values.components.postgres.clusterNameOverride }}
  {{- else -}}
    {{ include "appName" . }}
  {{- end -}}
{{- end -}}

{{- define "databaseHostname" -}}
  {{- if .Values.database.hostnameOverride -}}
    {{ .Values.database.hostnameOverride }}
  {{- else -}}
    {{ include "postgresClusterName" . }}
  {{- end -}}
{{- end -}}

{{- define "ingressHttpScheme" -}}
  {{- if .Values.components.ingress.tls.enabled -}}
    https
  {{- else -}}
    http
  {{- end -}}
{{- end -}}

{{- define "ingressBaseUrl" -}}
  {{ include "ingressHttpScheme" . }}://{{ .Values.components.ingress.host }}
{{- end -}}

{{- define "panelUrl" -}}
  {{ include "ingressBaseUrl" . }}{{ .Values.components.panel.publicPath }}
{{- end -}}

{{- define "panelOidcAudience" -}}
  {{- if .Values.components.panel.oidc.audience -}}
    {{ .Values.components.panel.oidc.audience }}
  {{- else -}}
    {{ include "panelUrl" . }}/
  {{- end }}
{{- end }}

{{- define "fuegoUrl" -}}
  {{ include "ingressBaseUrl" . }}
{{- end -}}

{{- define "fhirBaseUrl" -}}
  {{ include "ingressBaseUrl" . }}{{ .Values.components.ingress.fhirPath }}
{{- end -}}

{{- define "keycloakPublicUrl" -}}
  {{ include "ingressBaseUrl" . }}{{ .Values.components.keycloak.publicPath }}
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
    {{ include "keycloakPublicUrl" . }}/realms/{{ .Values.components.keycloak.importRealm.realmName }}/.well-known/openid-configuration
  {{- end -}}
{{- end -}}

{{- define "fuegoOidcAudience" -}}
  {{ include "fuegoUrl" . }}{{ .Values.components.ingress.fhirPath }}/
{{- end -}}

{{- define "internalFuegoUrl" -}}
  http://{{ include "fuegoAppName" . }}.{{ .Release.Namespace }}.svc.cluster.local
{{- end -}}

{{- define "internalFhirBaseUrl" -}}
  {{ include "internalFuegoUrl" . }}{{ .Values.components.ingress.fhirPath }}
{{- end -}}

{{- define "backupTargetSecretName" -}}
  {{ include "appName" . }}-backup-target
{{- end -}}
