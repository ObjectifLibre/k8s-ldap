{{- /*
Copyright 2018 ObjectifLibre

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/ -}}
{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "k8s-ldap.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "k8s-ldap.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- $fullname := printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- default $fullname .Values.fullNameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "k8s-ldap.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Dex fully qualified app name.
*/}}
{{- define "k8s-ldap.dex.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s-%s" .Release.Name $name .Values.dex.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Loginapp fully qualified app name.
*/}}
{{- define "k8s-ldap.loginapp.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s-%s" .Release.Name $name .Values.loginapp.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Keycloak fully qualified app name.
*/}}
{{- define "k8s-ldap.keycloakProxy.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s-%s" .Release.Name $name .Values.keycloakProxy.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
