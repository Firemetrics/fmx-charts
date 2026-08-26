# Spec: Client-Facing Kubernetes Metrics Stack (fmx-monitoring)

Status: ready-for-agent
Repos affected: fmx-charts (primary), fmx-cluster (Traefik metrics exposure)

## Problem Statement

Clients operating a Firemetrics instance on their own k3s cluster have almost no
visibility into the health of that cluster. The only monitoring that exists today is
two manually-checked HTTP health endpoints (Fuego's `$healthcheck` FHIR operation and
the patient dashboard's `/api/health`), point-in-time only, with no history. There is
no metrics collection, no time-series storage, and no infrastructure dashboard: the
Grafana instance shipped with the stack is wired only to the clinical Postgres
database (and optionally Loki for logs). Failures that matter most on single-node
clusters — a disk filling up, a PVC running out of space, a pod restart-looping, a
TLS certificate expiring — are invisible until they cause an outage. Hospital IT
staff are told to "keep an eye on CPU and memory" with `kubectl`, which is not a
monitoring story.

## Solution

Ship a metrics pipeline as a first-class component of the fmx-instance stack: Grafana
Alloy (already present as the log collector) becomes the single telemetry collector,
gathering node, container, Kubernetes-object, ingress, certificate, and synthetic
endpoint-health metrics and remote-writing them to a small storage-only Prometheus.
The existing Grafana gets a Prometheus datasource and one opinionated, provisioned
"FMX Cluster Health" dashboard designed for a hospital-IT audience: node CPU / memory
/ disk, PVC fill levels, pod health and restarts, health-endpoint uptime, ingress
traffic and error rates, and certificate expiry. The whole stack is toggled by a
single component flag, sized so it can never cause the disk pressure it is meant to
warn about, and works in air-gapped installs through the existing Nexus mirror.

## User Stories

1. As a hospital IT administrator, I want a ready-to-go Grafana dashboard showing the
   health of my Firemetrics cluster, so that I can assess the installation without
   kubectl knowledge.
2. As a hospital IT administrator, I want to see node CPU, memory, and disk usage over
   time, so that I can spot capacity problems before they cause outages.
3. As a hospital IT administrator, I want to see the fill level of every persistent
   volume (Postgres, Loki, Grafana, MinIO), so that I know before a database volume
   runs full.
4. As a hospital IT administrator, I want to see pod health — not-ready pods, restart
   counts, OOM kills — so that I can tell whether the stack's workloads are stable.
5. As a hospital IT administrator, I want an uptime history of the stack's health
   endpoints (Fuego `$healthcheck`, Grafana, Keycloak), so that a point-in-time manual
   check is replaced by a continuous record.
6. As a hospital IT administrator, I want to see HTTP traffic and error rates at the
   ingress, so that I know whether users are currently experiencing failures.
7. As a hospital IT administrator, I want a countdown of days until TLS certificate
   expiry, so that certificates are renewed before browsers show warnings.
8. As a hospital IT administrator, I want the whole monitoring stack enabled with a
   single configuration flag, so that turning it on is not a project.
9. As a hospital IT administrator, I want the monitoring stack's own disk usage capped
   with a hard limit, so that monitoring can never be the cause of node disk pressure.
10. As a hospital IT administrator, I want dashboard panels for absent components
    (e.g. a scrape that is disabled) to show "no data" rather than errors, so that the
    dashboard stays trustworthy.
11. As a hospital IT administrator, I want to export any panel's data as CSV or print
    the dashboard from the browser, so that I can attach evidence to internal reports.
12. As a Firemetrics support engineer, I want ~10 days of metrics history retained at
    a client site, so that I can diagnose an incident after the fact instead of only
    while it happens.
13. As a Firemetrics support engineer, I want scrape health itself visible (collector
    up/down, targets reachable), so that "the dashboard is empty" is diagnosable.
14. As a Firemetrics operator, I want log shipping (Loki) and metrics collection to be
    independently toggleable, so that a client can run either without paying for both.
15. As a Firemetrics operator, I want a client who replaces Traefik or cert-manager
    with their own infrastructure to be able to disable those scrapes via values, so
    that the stack does not assume components that are not there.
16. As a Firemetrics operator at an air-gapped site, I want every new image pulled
    through the existing Nexus wildcard mirror, so that no new registry wiring is
    needed on the cluster.
17. As a Firemetrics developer, I want the set of stored metrics to be an explicit,
    auditable keep-list, so that Prometheus sizing stays predictable and every stored
    series has a consumer.
18. As a Firemetrics developer, I want one Alloy instance owning both the logs and
    metrics pipelines, so that there is a single collector to configure, debug, and
    upgrade.
19. As a Firemetrics release engineer, I want the new chart versioned and published in
    lock-step with the other fmx-charts, so that release tooling is unchanged.
20. As an operator upgrading an existing install, I want the migration of Alloy from
    the Loki chart documented (including the one-time prune of old resources), so that
    the upgrade does not leave a duplicate collector shipping logs twice.
21. As a hospital security officer, I want Prometheus reachable only inside the
    cluster, so that metrics about the hospital's infrastructure are not exposed.
22. As a Grafana user with a viewer role, I want the infrastructure dashboard
    provisioned read-only alongside the clinical dashboards, so that it cannot be
    accidentally edited or deleted.
23. As a Firemetrics developer, I want the RBAC objects of the collector to have
    release-scoped names, so that two releases in different namespaces cannot collide
    on cluster-scoped resources.

## Implementation Decisions

- **New chart `fmx-monitoring`** in fmx-charts, wired into `fmx-instance` as an
  Argo CD Application following the existing child-application pattern (chart
  selection helper, lock-stepped `chartRevision`, `valuesOverride` escape hatch,
  shared `syncPolicy`, destination namespace = release namespace).
- **Gating**: the fmx-monitoring Application is created when
  `components.monitoring.enabled` **or** `components.loki.enabled` is true. Inside the
  chart, the metrics pipeline (Prometheus, kube-state-metrics, metrics blocks of the
  Alloy config) activates with the monitoring flag; the log pipeline activates with
  the Loki flag. The two are independent.
- **Alloy moves** from the fmx-loki chart into fmx-monitoring. fmx-loki keeps only
  Loki (deployment, config, PVC, service). The Alloy log pipeline is carried over
  unchanged — including the JSON label extraction whose `fmx_service_name` /
  `fmx_audit_event_type` labels fmx-panel's audit-logs page depends on, and the
  Loki push URL derived from the Loki service name and release namespace. The
  Loki-service coordinates are passed to fmx-monitoring via values from fmx-instance.
- **Single-node design**: one Alloy DaemonSet runs all scrapes. On multi-node clusters
  cluster-level scrapes would duplicate; this is documented as a known limitation, not
  handled (no Alloy clustering, no second deployment).
- **Alloy metrics pipeline** consists of: the embedded node exporter
  (`prometheus.exporter.unix`), kubelet and cAdvisor scrapes (for container metrics
  and kubelet volume stats), a kube-state-metrics scrape, a Traefik scrape and a
  cert-manager scrape (each behind its own values toggle, both **default on**), and
  the embedded blackbox prober doing internal-only HTTP probes of a fixed target set:
  Fuego's `$healthcheck`, Grafana's health API, and Keycloak — via their cluster
  service DNS names. No externally-routed (public FQDN) probes. No user-extensible
  probe-target mechanism.
- **Keep-list**: all metrics pass a name-based allowlist relabel before remote write.
  Only metrics consumed by the shipped dashboard (plus scrape-health basics like `up`)
  are stored. Adding a panel that needs a new metric requires extending the keep-list;
  history for that metric starts at that moment.
- **Prometheus** is a single-binary, storage-only TSDB: remote-write receiver enabled,
  no scrape configuration of its own. Sizing: 10 days time retention, 4GB size-based
  retention as a hard backstop, 5Gi PVC (cluster-default storage class, consistent
  with all other PVCs in the stack), 60-second scrape interval. ClusterIP service
  only; no ingress, no auth, no NetworkPolicy (consistent with the rest of the stack;
  only Grafana queries it).
- **kube-state-metrics** runs as a one-replica deployment with its collector set
  trimmed to the resource types the dashboard uses (pods, deployments, daemonsets,
  statefulsets, nodes, PVCs, jobs).
- **Grafana integration**: the fmx-grafana chart gains a conditional Prometheus
  datasource following the existing conditional-Loki-datasource pattern, with the
  in-cluster Prometheus URL computed by an fmx-instance helper and passed through the
  Grafana child-application values. One new provisioned dashboard, "FMX Cluster
  Health", ships in a separate provisioned folder ("Infrastructure") alongside the
  clinical examples, read-only (`disableDeletion`, no UI updates). It is custom-built
  for the hospital-IT audience; community dashboards are deliberately not imported
  (they assume the full kube-prometheus-stack metric set and conflict with the
  keep-list approach), though proven panel queries may be borrowed.
- **Dashboard panels**: node CPU / memory / disk usage; PVC fill per claim; pod
  status, restarts and OOM terminations; health-endpoint probe status and uptime;
  Traefik request rate and 4xx/5xx error rate; certificate days-to-expiry; collector
  and target scrape health.
- **fmx-cluster change**: the Traefik Helm install in the infrastructure playbook
  gains the values needed to expose Traefik's Prometheus metrics endpoint in-cluster
  (metrics service enabled). cert-manager needs no change (its metrics port is already
  served on its service).
- **RBAC fix in passing**: the Alloy ServiceAccount/ClusterRole/ClusterRoleBinding
  names become release-and-namespace-scoped, fixing the existing collision between
  releases. The existing ClusterRole rule set already covers metrics discovery; the
  kubelet/cAdvisor scrape additionally requires the `nodes/metrics` resource.
- **Migration (documented, not automated)**: because child applications sync with
  `prune: false`, removing Alloy from fmx-loki leaves the old DaemonSet and RBAC
  orphaned; the upgrade notes prescribe the one-time prune. The Grafana pod must be
  restarted (or is restarted by the image/values change) to load the new datasource,
  since datasource ConfigMap changes are not checksum-annotated.
- **Nexus prerequisite (verify once, outside the repos)**: the registry mirror is a
  wildcard pull-through; confirm with the Nexus administrator that the upstreams for
  the Prometheus and kube-state-metrics images are proxied.

## Testing Decisions

- The testing seam is the **rendered-manifest surface**: `helm lint` plus
  `helm template` on the touched charts, inspecting rendered output — never template
  internals. Per repo convention (no test harness exists; lint and template dry-runs
  are the documented workflow), this validation is performed **manually during
  development**, not persisted as a test script.
- Render matrix to verify once during the build: fmx-instance with (monitoring on,
  loki on), (monitoring on, loki off), (monitoring off, loki on), (monitoring off,
  loki off) — checking the fmx-monitoring Application appears exactly when it should,
  and the generated Alloy configuration contains the metrics blocks / log blocks
  matching the flags. Likewise: scrape toggles remove exactly their scrape block,
  Prometheus flags and PVC size render from values, the Grafana datasources ConfigMap
  gains the Prometheus entry exactly when monitoring is enabled, and fmx-loki renders
  no Alloy resources after the move.
- Dashboard JSON: validated by loading in a rendered Grafana (manual/visual check).
- A good check here inspects what a cluster would receive (manifest shape, config
  content), not how templates compute it.

## Out of Scope

- **Alerting** (Grafana alert rules, contact points, notification channels) — designed
  follow-up, not in this build.
- **Probe-hygiene fixes to workload charts** (Fuego liveness/readiness values, probes
  for Panel/Keycloak/DICOM, resource requests/limits) — separate PR series; changes
  production restart behavior and deserves its own review.
- **The client operations document** ("what to routinely check") — separate
  deliverable that will reference this dashboard once it exists.
- **External (public-FQDN) endpoint probes** — deferred until the
  bring-your-own-proxy question settles.
- **Patient dashboard monitoring** — the dashboard is deployed separately (often via
  docker-compose, outside the cluster) and is not part of every installation; no
  probe target and no extensibility mechanism for it in this build.
- **Multi-node scrape deduplication** (Alloy clustering or a split
  DaemonSet/Deployment topology) — single-node design documented as a limitation.
- **Scheduled/exportable PDF reports** — Grafana Enterprise feature; the
  image-renderer plugin was evaluated and rejected (Chromium footprint on single-node
  clients). A possible future follow-up is a CronJob that queries Prometheus and
  publishes a static HTML report behind Keycloak, following the existing
  `/controlling` hosting pattern.
- **NetworkPolicies / Prometheus auth** — no precedent in the stack; ClusterIP-only
  exposure accepted.
- **kube-prometheus-stack or community dashboard imports** — rejected in favor of the
  lightweight custom stack and one opinionated dashboard.

## Further Notes

- Health-endpoint semantics worth remembering when the ops document is written:
  Fuego's `$healthcheck` is strictly binary (200/500, OperationOutcome); the patient
  dashboard returns 503 for both its `degraded` and `unhealthy` states; the DICOM
  receiver's `/health` is a stub that always returns 200. Known small bugs recorded
  during exploration: Fuego's failure response nests the `issue` array (invalid FHIR
  shape), and the German handbook shows a stale health-response example.
- The Argo CD Application health rollup remains the closest thing to a whole-stack
  health signal and should feature in the ops document alongside this dashboard.
- Postgres backup monitoring ("age of last successful WAL archive") becomes relevant
  once backups are enabled by default; the keep-list approach accommodates it later.
