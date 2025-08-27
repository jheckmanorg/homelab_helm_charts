{{/*
Template for flexible init containers including sidecar support
*/}}
{{- define "common.initcontainers" -}}
{{- if .Values.initContainers }}
initContainers:
{{- range .Values.initContainers }}
  - name: {{ .name }}
    image: "{{ .image.repository }}:{{ .image.tag | default "latest" }}"
    {{- if .image.pullPolicy }}
    imagePullPolicy: {{ .image.pullPolicy }}
    {{- end }}
    {{- if .restartPolicy }}
    restartPolicy: {{ .restartPolicy }}
    {{- end }}
    {{- if .securityContext }}
    securityContext:
      {{- toYaml .securityContext | nindent 6 }}
    {{- end }}
    {{- if .command }}
    command:
      {{- toYaml .command | nindent 6 }}
    {{- end }}
    {{- if .args }}
    args:
      {{- toYaml .args | nindent 6 }}
    {{- end }}
    {{- if .env }}
    env:
      {{- toYaml .env | nindent 6 }}
    {{- end }}
    {{- if .volumeMounts }}
    volumeMounts:
      {{- toYaml .volumeMounts | nindent 6 }}
    {{- end }}
    {{- if .resources }}
    resources:
      {{- toYaml .resources | nindent 6 }}
    {{- end }}
{{- end }}
{{- end }}
{{- end -}}