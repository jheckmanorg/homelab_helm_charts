{{/*
Template for one or multiple cronjobs
*/}}
{{- define "common.cronjobs" -}}
{{- range $job := .Values.cronJobs }}
---
apiVersion: batch/v1
kind: CronJob
metadata:
  name: {{ $.Release.Name }}-{{ $job.name }}
  labels:
    {{- include "common.labels" $ | nindent 4 }}
spec:
  schedule: "{{ $job.schedule }}"
  jobTemplate:
    spec:
      template:
        spec:
          {{- with $.Values.imagePullSecrets }}
          imagePullSecrets:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          containers:
          - name: {{ $job.name }}
            image: "{{ $job.image | default $.Values.image.repository }}:{{ $job.tag | default ($.Values.image.tag | default "latest") }}"
            imagePullPolicy: {{ $.Values.image.pullPolicy | default "IfNotPresent" }}
            {{- if $job.command }}
            command: 
              {{- toYaml $job.command | nindent 14 }}
            {{- end }}
            {{- if $job.args }}
            args:
              {{- toYaml $job.args | nindent 14 }}
            {{- end }}
            {{- if $job.env }}
            env:
              {{- toYaml $job.env | nindent 14 }}
            {{- end }}
            {{- if $job.resources }}
            resources:
              {{- toYaml $job.resources | nindent 14 }}
            {{- end }}
            {{- if $job.volumeMounts }}
            volumeMounts:
              {{- toYaml $job.volumeMounts | nindent 14 }}
            {{- end }}
          restartPolicy: {{ $job.restartPolicy | default "OnFailure" }}
          {{- if $.Values.volumes }}
          volumes:
            {{- toYaml $.Values.volumes | nindent 10 }}
          {{- end }}
{{- end }}
{{- end -}}
