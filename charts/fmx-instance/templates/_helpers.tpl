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

{{- define "databaseHostname" -}}
  {{- if .Values.database.hostnameOverride -}}
    {{ .Values.database.hostnameOverride }}
  {{- else -}}
    {{ include "postgresAppName" . }}
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

{{- define "resourceReaderSaName" -}}
  {{ include "appName" . }}-resource-reader
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

{{- define "bootstrapJob" -}}
  {{ include "bootstrapAppName" . }}
{{- end -}}

{{- define "waitForBootstrapInitContainer" -}}
- name: wait-for-bootstrap
  image: bitnami/kubectl:1.33.3
  command:
    - /bin/bash
    - -c
    - |
      echo "Waiting for bootstrap job to complete..."
      until kubectl get job/{{ include "bootstrapJob" . }} -o jsonpath='{.status.conditions[?(@.type=="Complete")].status}' | grep True; do
        echo "Not complete yet..."
        sleep 5
      done
      echo "Bootstrap job is complete."
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
