{{/*
Expand the name of the chart.
*/}}
{{- define "reactive-resume.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "reactive-resume.secert-key-name" -}}
secret-key-{{ include "reactive-resume.name" . | trunc 63 }}
{{- end }}

{{- define "reactive-resume.jwt-secret-name" -}}
jwt-secret-{{ include "reactive-resume.name" . | trunc 63 }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "reactive-resume.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "reactive-resume.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "reactive-resume.labels" -}}
helm.sh/chart: {{ include "reactive-resume.chart" . }}
{{ include "reactive-resume.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "reactive-resume.selectorLabels" -}}
app.kubernetes.io/name: {{ include "reactive-resume.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "reactive-resume.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "reactive-resume.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Generate Client environment variables
*/}}
{{- define "reactive-resume.clientEnv" -}}
{{- if .Values.env }}
{{- toYaml .Values.env }}
{{- end -}}
- name: "PUBLIC_URL"
  value: {{ .Values.publicUrl }}
- name: "PUBLIC_SERVER_URL"
  value: {{ .Values.publicServerUrl }}
{{- if .Values.GoogleAuthSecretName }}
- name: "PUBLIC_GOOGLE_CLIENT_ID"
  valueFrom:
    secretKeyRef:
      name: {{ .Values.GoogleAuthSecretName }}
      key: "PUBLIC_GOOGLE_CLIENT_ID"
{{- end }}
{{- end }}

{{/*
Generate Server environment variables
*/}}
{{- define "reactive-resume.serverEnv" -}}
{{- include "reactive-resume.clientEnv" . }}
- name: "POSTGRES_HOST"
  value: "{{ .Values.postgresHost }}"
- name: "POSTGRES_PORT"
  value: "{{ .Values.postgresPort }}"
- name: "POSTGRES_DB"
  value: "{{ .Values.postgresDatabase }}"
- name: "POSTGRES_USER"
  value: "{{ .Values.postgresUser }}"
- name: "POSTGRES_PASSWORD"
{{- if .Values.postgresPasswordSecretName }}
  valueFrom:
    secretKeyRef:
      name: "{{ .Values.postgresPasswordSecretName }}"
      key: "POSTGRES_PASSWORD"
{{- else }}
  value: "{{ .Values.postgresPassword }}"
{{- end }}
{{- if .Values.postgresSslCert }}
- name: "POSTGRES_SSL_CERT"
  value: "{{ .Values.postgresSslCert }}"
{{- end }}
- name: "SECRET_KEY"
{{- if .Values.secretKey }}
  value: "{{ .Values.secretKey }}"
{{- else }}
  valueFrom:
    secretKeyRef:
      name:  "{{ include "reactive-resume.secert-key-name" . }}"
      key: "SECRET_KEY"
{{- end }}
- name: "JWT_SECRET"
{{- if .Values.jwtSecret }}
  value: "{{ .Values.jwtSecret }}"
{{- else }}
  valueFrom:
    secretKeyRef:
      name:  "{{ include "reactive-resume.secert-key-name" . }}"
      key: "JWT_SECRET"
{{- end }}
- name: "JWT_EXPIRY_TIME"
  value: "{{ .Values.jwtExpiryTime }}"
{{- if .Values.GoogleAuthSecretName }}
- name: "GOOGLE_CLIENT_SECRET"
  valueFrom:
    secretKeyRef:
      name: "{{ .Values.GoogleAuthSecretName }}"
      key: "GOOGLE_CLIENT_SECRET"
- name: "GOOGLE_API_KEY"
  valueFrom:
    secretKeyRef:
      name: "{{ .Values.GoogleAuthSecretName }}"
      key: "GOOGLE_API_KEY"
{{- end }}
{{- if .Values.S3StorageSecretName }}
- name: "MAIL_FROM_NAME"
  valueFrom:
    secretKeyRef:
      name: "{{ .Values.S3StorageSecretName }}"
      key: "MAIL_FROM_NAME"
- name: "MAIL_FROM_EMAIL"
  valueFrom:
    secretKeyRef:
      name: "{{ .Values.S3StorageSecretName }}"
      key: "MAIL_FROM_EMAIL"
- name: "MAIL_HOST"
  valueFrom:
    secretKeyRef:
      name: "{{ .Values.S3StorageSecretName }}"
      key: "MAIL_HOST"
- name: "MAIL_PORT"
  valueFrom:
    secretKeyRef:
      name: "{{ .Values.S3StorageSecretName }}"
      key: "MAIL_PORT"
- name: "MAIL_USERNAME"
  valueFrom:
    secretKeyRef:
      name: "{{ .Values.S3StorageSecretName }}"
      key: "MAIL_USERNAME"
- name: "MAIL_PASSWORD"
  valueFrom:
    secretKeyRef:
      name: "{{ .Values.S3StorageSecretName }}"
      key: "MAIL_PASSWORD"
{{- end }}
{{- if .Values.S3StorageSecretName }}
- name: "STORAGE_BUCKET"
  valueFrom:
    secretKeyRef:``
      name: "{{ .Values.S3StorageSecretName }}"
      key: "STORAGE_BUCKET"
- name: "STORAGE_REGION"
  valueFrom:
    secretKeyRef:
      name: "{{ .Values.S3StorageSecretName }}"
      key: "STORAGE_REGION"
- name: "STORAGE_ENDPOINT"
  valueFrom:
    secretKeyRef:
      name: "{{ .Values.S3StorageSecretName }}"
      key: "STORAGE_ENDPOINT"
- name: "STORAGE_URL_PREFIX"
  valueFrom:
    secretKeyRef:
      name: "{{ .Values.S3StorageSecretName }}"
      key: "STORAGE_URL_PREFIX"
- name: "STORAGE_ACCESS_KEY"
  valueFrom:
    secretKeyRef:
      name: "{{ .Values.S3StorageSecretName }}"
      key: "STORAGE_ACCESS_KEY"
- name: "STORAGE_SECRET_KEY"
  valueFrom:
    secretKeyRef:
      name: "{{ .Values.S3StorageSecretName }}"
      key: "STORAGE_SECRET_KEY"
{{- end }}
{{- if .Values.pdfDeletionTime }}
- name: "PDF_DELETION_TIME"
  value: "{{ .Values.pdfDeletionTime }}"
{{- end }}
{{- end }}