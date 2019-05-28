{{/* Generate basic labels */}}
{{- define "jira-chart.labels" }}
  generator: helm
  date: {{ now | htmlDate }}
  chart: {{ .Chart.Name }}
  version: {{ .Chart.Version }}
  app_name: {{ .Chart.Name }}
  app_version: {{ .Values.Image.Tag }}
  release: {{ .Release.Name }}
  heritage: {{ .Release.Service }}
{{- end }}
