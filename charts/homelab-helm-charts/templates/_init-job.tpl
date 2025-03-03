{{/*
Template for an initialization job, meant to run migrations and setup the database if not already setup
*/}}
{{- define "common.init-job" -}}
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ include "common.fullname" . }}-init
  labels:
    {{- include "common.labels" . | nindent 4 }}
  annotations:
    "helm.sh/hook": post-install,post-upgrade
    "helm.sh/hook-weight": "0"
    "helm.sh/hook-delete-policy": before-hook-creation,hook-succeeded
spec:
  template:
    metadata:
      labels:
        {{- include "common.selectorLabels" . | nindent 8 }}
    spec:
      {{- with .Values.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      serviceAccountName: {{ include "common.serviceAccountName" . }}
      securityContext:
        runAsNonRoot: true
        runAsUser: 1000
      containers:
        - name: init
          securityContext:
            allowPrivilegeEscalation: false
            capabilities:
              drop:
                - ALL
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default "latest" }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          {{- if .Values.initJob.command }}
          command: 
            {{- toYaml .Values.initJob.command | nindent 12 }}
          {{- end }}
          {{- if .Values.initJob.args }}
          args:
            {{- toYaml .Values.initJob.args | nindent 12 }}
          {{- end }}
          env:
            {{- include "common.mergeEnv" . | nindent 12 }}
          resources:
            {{- toYaml .Values.initJob.resources | nindent 12 }}
      restartPolicy: OnFailure
{{- end -}}
