{{- define "appName" -}}
  {{ .Release.Name }}
{{- end }}

{{- define "importRealmConfigMapName" -}}
  {{ include "appName" . }}-import-realm
{{- end }}

{{- define "podLabel" -}}
  {{ include "appName" . }}
{{- end -}}

{{- define "svcName" -}}
  {{- if .Values.service.nameOverride -}}
    {{ .Values.service.nameOverride }}
  {{- else -}}
    {{ include "appName" . }}
  {{- end -}}
{{- end -}}

{{- define "adminSecretName" -}}
  {{- if .Values.adminSecret.nameOverride -}}
    {{ .Values.adminSecret.nameOverride }}
  {{- else -}}
    {{ include "appName" . }}-admin
  {{- end -}}
{{- end -}}

{{- define "databaseUserSecretName" -}}
  {{- if .Values.database.userSecret.nameOverride -}}
    {{ .Values.database.userSecret.nameOverride }}
  {{- else -}}
    {{ include "appName" . }}-db-user
  {{- end -}}
{{- end -}}

{{- define "randomPassword" -}}
  {{- $secretData := (lookup "v1" "Secret" .context.Release.Namespace .secret).data -}}
  {{- if $secretData -}}
    {{- if hasKey $secretData .key -}}
      {{ index $secretData .key | b64dec }}
    {{- else -}}
      {{- printf "\nPASSWORDS ERROR: The secret \"%s\" does not contain the key \"%s\"\n" .secret .key | fail -}}
    {{- end -}}
  {{- else -}}
    {{ randAlphaNum 16 }}
  {{- end -}}
{{- end }}

{{- define "podHttpPort" -}}
  8080
{{- end }}
