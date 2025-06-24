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

{{- define "panel.podLabel" -}}
{{- .Release.Name }}-panel
{{- end }}

{{- define "panel.svcName" -}}
{{- .Release.Name }}-panel
{{- end }}
