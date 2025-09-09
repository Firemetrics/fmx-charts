# Changelog

All notable changes to this project will be documented in this file.

## [1.5.3] - 2025-09-09

### 🐛 Bug Fixes

- Fix queue worker startup
- Update default Panel image ref
## [1.5.2] - 2025-09-04

### 🐛 Bug Fixes

- Upgrade Panel to v1.0.5
## [1.5.1] - 2025-09-04

### 🐛 Bug Fixes

- Upgrade Grafana to `01e5524`
- Delete defunctional Grafana dashboards
- Rename dashboard examples folder
## [1.5.0] - 2025-09-04

### 🚀 Features

- Add Panel bootstrap process

### 🐛 Bug Fixes

- Upgrade Grafana image ref
- Update default Panel image ref
- Disable prune and self-heal by default
- Update Panel to `v1.0.4`
## [1.4.2] - 2025-09-03

### 🐛 Bug Fixes

- Fix default Postgres image ref
- Update default Grafana image ref
## [1.4.1] - 2025-09-03

### 🐛 Bug Fixes

- Upgrade Panel default version
## [1.4.0] - 2025-09-01

### 🚀 Features

- Upgrade Panel to `f87c1ce`

### 🐛 Bug Fixes

- Clean up Panel configuration
## [1.3.1] - 2025-08-29

### 🐛 Bug Fixes

- Add `groups` claim to tokens by default
## [1.3.0] - 2025-08-29

### 🚀 Features

- Add authorization for Grafana users
## [1.2.0] - 2025-08-29

### 🚀 Features

- Add persistence to Grafana

### 🐛 Bug Fixes

- Fix initial Keycloak OIDC username claim
- Fix Grafana data volume name
## [1.1.1] - 2025-08-29

### 🐛 Bug Fixes

- Remove Grafana admin user secret setting
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
