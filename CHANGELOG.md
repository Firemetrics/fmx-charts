# Changelog

All notable changes to this project will be documented in this file.

## [1.14.4] - 2026-02-27

### 🐛 Bug Fixes

- Update default fmx-panel image to v1.5.0
## [1.14.3] - 2026-02-25

### 🐛 Bug Fixes

- Update default fmx-panel image to v1.4.0
- Update default Firemetrics images to v0.8.6
## [1.14.2] - 2026-02-16

### 🐛 Bug Fixes

- Update default Firemetrics images
## [1.14.1] - 2026-02-06

### 🐛 Bug Fixes

- Update default Firemetrics images
## [1.14.0] - 2026-02-06

### 🚀 Features

- Add fmx-loki chart for log aggregation
- Centralize Firemetrics image version management

### 🐛 Bug Fixes

- Update default Firemetrics images
## [1.13.3] - 2026-01-26

### 🐛 Bug Fixes

- Update default Firemetrics images
## [1.13.2] - 2026-01-16

### 🐛 Bug Fixes

- Update default Firemetrics images
## [1.13.1] - 2026-01-08

### 🐛 Bug Fixes

- Fix `dicom`-schema access from SQL editor
## [1.13.0] - 2025-12-18

### 🚀 Features

- Support configuration of referential integrity
- Allow configuration of external database access

### 🐛 Bug Fixes

- Configure startup probe for Fuego deployment
## [1.12.1] - 2025-12-17

### 🐛 Bug Fixes

- Update default Admin Panel image
- Update default Firemetrics images
## [1.12.0] - 2025-12-03

### 🚀 Features

- Update Firemetrics images to latest version

### 🐛 Bug Fixes

- Fix Keycloak bootstrap config
- Update default Admin Panel image
## [1.11.0] - 2025-11-14

### 🚀 Features

- Support ingress port configuration
## [1.10.0] - 2025-11-13

### 🚀 Features

- Update Firemetrics images to latest version

### 🐛 Bug Fixes

- Fix Keycloak realm URL template
- Fix Keycloak realm URL template
## [1.9.3] - 2025-10-28

### 🐛 Bug Fixes

- Fix Keycloak CA bundle configuration
- Remove unused Keycloak config values
## [1.9.2] - 2025-10-23

### 🐛 Bug Fixes

- Fix Grafana custom CA config
- Disable Fuego health check by default
## [1.9.1] - 2025-10-23

### 🐛 Bug Fixes

- Fix grafana Keycloak bootstrapping

### 📚 Documentation

- Change namespace placeholder
- Clean up documentation about secret generation
## [1.9.0] - 2025-10-21

### 🚀 Features

- Add healthchecks for Fuego service
- Add healthchecks for Grafana service

### 🐛 Bug Fixes

- Clean up DICOMweb service configuration
## [1.8.1] - 2025-10-20

### 🐛 Bug Fixes

- Enable MinIO by default

### 📚 Documentation

- Update readme
## [1.8.0] - 2025-10-20

### 🚀 Features

- Add DICOMweb service
## [1.7.0] - 2025-10-14

### 🚀 Features

- Support exposing MinIO service
- Add DICOM Receiver service

### 🐛 Bug Fixes

- Change Panel feature flags enabeld by default
## [1.6.0] - 2025-10-01

### 🚀 Features

- Add HAPI facade service

### 📚 Documentation

- Add documentation about charts architecture

### ⚙️ Miscellaneous Tasks

- Remove unnecessary README PDF
- Remove helm-docs comments in readmes
## [1.5.5] - 2025-09-19

### 🐛 Bug Fixes

- Enable resource_explorer feature by default

### ⚙️ Miscellaneous Tasks

- Add CLAUDE.md
## [1.5.4] - 2025-09-10

### 🐛 Bug Fixes

- Update Panel image ref
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
