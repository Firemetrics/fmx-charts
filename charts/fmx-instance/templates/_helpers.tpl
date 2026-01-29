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

{{- define "grafanaAppName" -}}
  {{ include "appName" . }}-grafana
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

{{- define "receiverAppName" -}}
  {{ include "appName" . }}-dicom
{{- end -}}

{{- define "lokiAppName" -}}
  {{ include "appName" . }}-loki
{{- end -}}

{{- define "dicomDatabaseSchema" -}}
  dicom
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

{{- define "portUrlPart" -}}
  {{- if .Values.tls.enabled -}}
    {{- if ne (int .Values.ingress.https_port) 443 -}}
      :{{ .Values.ingress.https_port }}
    {{- end -}}
  {{- else -}}
    {{- if ne (int .Values.ingress.http_port) 80 -}}
      :{{ .Values.ingress.http_port }}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "fqdn" -}}
  {{- if .Values.hostname -}}
    {{ .Values.hostname }}
  {{- else -}}
    {{ .Values.ingress.fqdn }}
  {{- end -}}
{{- end -}}

{{- define "baseUrl" -}}
  {{ include "httpScheme" . }}://{{ include "fqdn" . }}{{ include "portUrlPart" . }}
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

{{- define "databaseSuperUserName" -}}
  postgres
{{- end -}}

{{- define "databaseSuperUserSecretName" -}}
  {{- if .Values.database.existingSuperUserSecret -}}
    {{ .Values.database.existingSuperUserSecret }}
  {{- else -}}
    {{ include "databaseSuperUserName" . }}.{{ include "databaseHostname" . }}.credentials.postgresql.acid.zalan.do
  {{- end -}}
{{- end -}}

{{- define "keycloakPublicUrl" -}}
  {{ include "baseUrl" . }}{{ .Values.components.keycloak.publicPath }}
{{- end -}}

{{- define "keycloakRealmUrl" -}}
  {{ include "keycloakPublicUrl" . }}/realms/{{ .Values.oidc.keycloakRealm }}
{{- end -}}

{{- define "oidcDiscoveryUrl" }}
  {{- if .Values.oidc.discoveryUrlOverride -}}
    {{ .Values.oidc.discoveryUrlOverride }}
  {{- else -}}
    {{ include "keycloakRealmUrl" . }}/.well-known/openid-configuration
  {{- end -}}
{{- end -}}

{{- define "oidcAuthUrl" }}
  {{- if .Values.oidc.authUrlOverride -}}
    {{ .Values.oidc.authUrlOverride }}
  {{- else -}}
    {{ include "keycloakRealmUrl" . }}/protocol/openid-connect/auth
  {{- end -}}
{{- end -}}

{{- define "oidcTokenUrl" }}
  {{- if .Values.oidc.tokenUrlOverride -}}
    {{ .Values.oidc.tokenUrlOverride }}
  {{- else -}}
    {{ include "keycloakRealmUrl" . }}/protocol/openid-connect/token
  {{- end -}}
{{- end -}}

{{- define "oidcUserinfoUrl" }}
  {{- if .Values.oidc.userinfoUrlOverride -}}
    {{ .Values.oidc.userinfoUrlOverride }}
  {{- else -}}
    {{ include "keycloakRealmUrl" . }}/protocol/openid-connect/userinfo
  {{- end -}}
{{- end -}}

{{- define "oidcSignoutUrl" }}
  {{- if .Values.oidc.signoutUrlOverride -}}
    {{ .Values.oidc.signoutUrlOverride }}
  {{- else -}}
    {{ include "keycloakRealmUrl" . }}/protocol/openid-connect/logout
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

{{- define "internalLokiUrl" -}}
  {{- if .Values.components.loki.service.nameOverride -}}
    http://{{ .Values.components.loki.service.nameOverride }}.{{ .Release.Namespace }}.svc.cluster.local
  {{- else -}}
    http://{{ include "lokiAppName" . }}-loki.{{ .Release.Namespace }}.svc.cluster.local
  {{- end -}}
{{- end -}}

{{- define "tlsCertSecretName" -}}
  {{- if .Values.tls.secretNameOverride -}}
    {{ .Values.tls.secretNameOverride }}
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

{{- define "chartRevision" -}}
  {{- if .Values.chartRevisionOverride -}}
    {{ .Values.chartRevisionOverride }}
  {{- else -}}
    {{ .Chart.Version }}
  {{- end -}}
{{- end -}}

{{- define "chartSelection" -}}
  {{- if hasSuffix ".git" .context.Values.chartRepoUrl -}}
    path: charts/{{ .chart }}
  {{- else -}}
    chart: {{ .chart }}
  {{- end -}}
{{- end -}}
