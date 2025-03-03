{{/*
Template for PostgreSQL dependency
*/}}
{{- define "common.postgresql-dependency" -}}
dependencies:
  - name: postgresql
    version: "12.x.x"
    repository: https://charts.bitnami.com/bitnami
    condition: postgresql.enabled
{{- end -}}
