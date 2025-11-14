{{- define "appName" -}}
  {{ .Release.Name }}
{{- end }}

{{- define "podLabel" -}}
  {{ include "appName" . }}
{{- end -}}

{{- define "pvcName" -}}
  {{ include "appName" . }}-data
{{- end -}}

{{- define "svcName" -}}
  {{- if .Values.service.nameOverride -}}
    {{ .Values.service.nameOverride }}
  {{- else -}}
    {{ include "appName" . }}
  {{- end -}}
{{- end -}}

{{- define "podHttpPort" -}}
  3000
{{- end }}

{{- define "httpScheme" -}}
  {{- if .Values.tls.enabled -}}
    https
  {{- else -}}
    http
  {{- end -}}
{{- end -}}

{{- define "exampleDashboardsConfigMapName" -}}
  {{ include "appName" . }}-dashboards-data
{{- end -}}

{{- define "dashboardsDataPath" -}}
  /opt/dashboards
{{- end -}}

{{- define "exampleDashboardsMountPath" -}}
  {{ include "dashboardsDataPath" . }}/Firemetrics Examples
{{- end -}}

{{- define "dashboardsConfigMapName" -}}
  {{ include "appName" . }}-dashboards
{{- end -}}

{{- define "dashboardsMountPath" -}}
  /etc/grafana/provisioning/dashboards
{{- end -}}

{{- define "datasourcesConfigMapName" -}}
  {{ include "appName" . }}-datasources
{{- end -}}

{{- define "datasourcesMountPath" -}}
  /etc/grafana/provisioning/datasources
{{- end -}}

{{- define "dbHostEnvVar" -}}
  FIREMETRICS_DB_HOST
{{- end -}}

{{- define "dbPortEnvVar" -}}
  FIREMETRICS_DB_PORT
{{- end -}}

{{- define "dbNameEnvVar" -}}
  FIREMETRICS_DB_NAME
{{- end -}}

{{- define "dbUsernameEnvVar" -}}
  FIREMETRICS_DB_USERNAME
{{- end -}}

{{- define "dbPasswordEnvVar" -}}
  FIREMETRICS_DB_PASSWORD
{{- end -}}

