{{- define "appName" -}}
  {{ .Release.Name }}
{{- end -}}

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

{{- define "oidcClientSecretName" -}}
  {{- if .Values.oidc.clientSecret.nameOverride -}}
    {{ .Values.oidc.clientSecret.nameOverride }}
  {{- else -}}
    {{ include "appName" . }}-oidc-client
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
    {{ randAlphaNum 24 }}
  {{- end -}}
{{- end -}}
