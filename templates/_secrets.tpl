{{/*
Template for application secrets. This still needs to be improved so an actual secret is made
*/}}
{{- define "common.secrets" -}}
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "common.fullname" . }}-secrets
  labels:
    {{- include "common.labels" . | nindent 4 }}
type: Opaque
data:
  {{- if .Values.secrets.django }}
  {{- if .Values.secrets.django.secretKey }}
  django-secret-key: {{ .Values.secrets.django.secretKey | b64enc }}
  {{- end }}
  {{- end }}
  {{- if .Values.secrets.custom }}
  {{- range $key, $value := .Values.secrets.custom }}
  {{ $key }}: {{ $value | b64enc }}
  {{- end }}
  {{- end }}
{{- end -}}
