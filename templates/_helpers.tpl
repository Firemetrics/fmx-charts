{{- define "appName" -}}
{{- .Release.Name }}
{{- end }}

{{- define "resourceReaderSaName" -}}
{{- .Release.Name }}-resource-reader
{{- end }}

{{- define "registry.secretName" -}}
{{- .Release.Name }}-registry
{{- end }}

{{- define "db.podLabel" -}}
{{- .Release.Name }}-db
{{- end }}

{{- define "db.svcName" -}}
{{- .Release.Name }}-db
{{- end }}

{{- define "db.pvcName" -}}
{{- .Release.Name }}-db-data
{{- end }}

{{- define "db.bootstrapJob" -}}
{{- .Release.Name }}-db-bootstrap
{{- end }}

{{- define "db.databaseUrl" -}}
{{ printf "postgresql://%s:%s@%s:5432/%s" .Values.db.pg.user .Values.db.pg.password (include "db.svcName" .) .Values.db.pg.dbname }}
{{- end }}

{{- define "keycloak.openidDiscoveryUrl" }}
  {{- if and .Values.ingress.enabled .Values.keycloak.enabled .Values.keycloak.importRealm.realmName -}}
    https://{{ .Values.ingress.host }}/auth/realms/{{ .Values.keycloak.importRealm.realmName }}/.well-known/openid-configuration
  {{- end }}
{{- end }}

{{- define "panel.podLabel" -}}
{{- .Release.Name }}-panel
{{- end }}

{{- define "panel.svcName" -}}
{{- .Release.Name }}-panel
{{- end }}

{{- define "fuego.podLabel" -}}
{{- .Release.Name }}-fuego
{{- end }}

{{- define "fuego.svcName" -}}
{{- .Release.Name }}-fuego
{{- end }}
