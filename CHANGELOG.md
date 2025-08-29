# Changelog

All notable changes to this project will be documented in this file.

## [1.1.0] - 2025-08-29

### 🚀 Features

- Add support for installing charts from Git
- Add Grafana component

### 🐛 Bug Fixes

- Remove unnecessary value from Keycloak chart
- Urlencode fuego bootstrap credentials
- Configure missing image pull secrets
- Set correct dashboards data directory
- Fix Keycloak sign-out URL
- Add email and profile scopes to init realm
- Add "full name" mapper to OIDC profile scope
- Fix Grafana OIDC configuration
- Configure Grafana role OIDC claim
- Fix Grafana datasource configuration
- Change mounting of Grafana example dashboards

### ⚙️ Miscellaneous Tasks

- Add git-cliff for changelog generation
