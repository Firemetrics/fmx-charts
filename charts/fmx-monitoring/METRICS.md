# FMX Cluster Health — Metrics Reference

Internal engineering reference for the **FMX Cluster Health** Grafana dashboard
(uid `fmx-cluster-health`, shipped by `fmx-grafana` under
`data/infrastructure/`). It documents every metric the dashboard consumes:
where it originates, which Alloy component collects it, how each panel queries
it, and how to interpret the result.

Applies to `fmx-monitoring` chart version 2.0.0-rc.1.

## Architecture

One collection path, no exceptions — every series on the dashboard flows
through the same pipeline:

```
exporters / endpoints
        │  scraped by Grafana Alloy (DaemonSet, one pod per node)
        ▼
prometheus.relabel "keep"      ← name-based allowlist (metrics.keepList)
        │                        + drop of unused cAdvisor aggregate series
        ▼
prometheus.remote_write        → local Prometheus (storage only,
                                 --web.enable-remote-write-receiver,
                                 10d / 4GB retention, 5Gi PVC, ClusterIP)
        ▼
Grafana datasource `prometheus` (provisioned by fmx-grafana when
                                 prometheus.enabled, timeInterval = scrapeInterval)
```

All scrapes and probes run at `metrics.scrapeInterval` (default **60s**).
Grafana's datasource `timeInterval` is wired to the same value so
`$__rate_interval` never falls below two scrape intervals.

### Scrape jobs

The `job` label on every stored series identifies the collector. These are the
seven jobs (all visible in the *Scrape targets* panel via `up`):

| `job` | Source | Alloy component | What it provides |
|---|---|---|---|
| `node` | Embedded node exporter reading host `/proc`, `/sys`, `/` (mounted read-only into the Alloy pod) | `prometheus.exporter.unix "node"` + `discovery.relabel "node"` (forces `job="node"`; the exporter would otherwise stamp `integrations/unix`) | Node CPU, memory, filesystem |
| `kubelet` | Kubelet HTTPS `/metrics` on the pod's own node (ServiceAccount bearer token, `insecure_skip_verify`; node discovery restricted with a field selector to `metadata.name == $HOSTNAME` so multi-node clusters don't scrape N×N) | `discovery.kubernetes "nodes"` + `prometheus.scrape "kubelet"` | PVC volume stats |
| `cadvisor` | Kubelet HTTPS `/metrics/cadvisor`, same node restriction and auth | `prometheus.scrape "cadvisor"` | Per-container CPU and memory |
| `kube-state-metrics` | KSM Deployment in the release namespace, HTTP port 8080. Exports only the resource kinds in `kubeStateMetrics.resources` (default: `pods`); its ClusterRole is derived from that list | `prometheus.scrape "kube_state_metrics"` | Pod phase, readiness, restart counters |
| `traefik` | `scrape.traefik.address` (default `traefik-metrics.traefik.svc.cluster.local:9100`; requires the fmx-cluster Traefik install with `metrics.prometheus.service.enabled`). Toggle: `scrape.traefik.enabled` | `prometheus.scrape "traefik"` | Ingress request/latency counters |
| `cert-manager` | `scrape.certManager.address` (default `cert-manager.cert-manager.svc.cluster.local:9402`). Toggle: `scrape.certManager.enabled` | `prometheus.scrape "cert_manager"` | Certificate expiry timestamps |
| `blackbox` | Embedded blackbox exporter probing the HTTP endpoints in `probes.targets` (module `http_2xx`, 5s timeout, success = any 2xx response). Per-target relabel rules map `__param_target` (the probed URL) to `instance=<name>`, so probe series carry a stable, human-readable `instance` | `prometheus.exporter.blackbox "endpoints"` + `discovery.relabel "endpoints"` + `prometheus.scrape "endpoints"` | `probe_success` per endpoint |

### Where the values originate

The metric names are contracts owned by their emitters, not by this chart.
Each source runs a plain-HTTP endpoint (conventionally `/metrics`) that, on
every request, prints a fresh snapshot of its current numbers in the
Prometheus text format — one line per series:

```
# HELP kube_pod_container_status_restarts_total The number of container restarts per container.
# TYPE kube_pod_container_status_restarts_total counter
kube_pod_container_status_restarts_total{namespace="fmx",pod="fmx-keycloak-0",container="keycloak"} 3
```

Nothing pushes: the emitters keep no history and remember nothing between
requests. History exists only because Alloy fetches each page every
`scrapeInterval`, timestamps the parsed samples, and remote-writes the
keep-listed ones to Prometheus. This text format is the de-facto standard for
"how a program publishes its numbers", which is why most cloud-native
software (Traefik, cert-manager, the kubelet, Grafana itself) ships the
endpoint out of the box.

The sources fall into three categories:

- **Synthesized by the monitoring pipeline itself:** `probe_success` is
  manufactured by the blackbox exporter from the outcome of the HTTP request
  it performs (the target only contributes a status code); `up` is
  synthesized by Alloy for every scrape it attempts, which is why it exists
  even for targets that are down.
- **Translated from another system's state:** kube-state-metrics measures
  nothing — it watches the Kubernetes API and republishes object fields
  (`kube_pod_container_status_restarts_total` is literally
  `status.containerStatuses[].restartCount`, the `kubectl get pods` RESTARTS
  column). Likewise the node exporter reads kernel files (`/proc/stat`,
  `/proc/meminfo`, `statfs()` on mountpoints), and the kubelet's
  `kubelet_volume_stats_*` come from `statfs()` on each PVC's mounted
  filesystem — the exact mechanism that has no implementation for hostPath
  volumes (see the PVC panel gap below).
- **Self-instrumented software:** cAdvisor (compiled into the kubelet, hence
  the `/metrics/cadvisor` path) republishes the kernel's per-cgroup CPU and
  memory accounting as `container_*` series; Traefik increments
  `traefik_entrypoint_requests_total` in its own request-handling code;
  cert-manager publishes each certificate's `notAfter` timestamp.

To see what a source offers beyond the keep-list, curl its endpoint directly
(e.g. `traefik-metrics.traefik.svc.cluster.local:9100/metrics` dumps every
Traefik metric, of which the keep-list stores three).

Every binary in this stack is a stock upstream open source component — Alloy
(Grafana Labs), Prometheus and the embedded node exporter
(`prometheus.exporter.unix` is the Prometheus project's
`node_exporter` collector code compiled into Alloy), the embedded blackbox
exporter (likewise), and kube-state-metrics (Kubernetes project). This chart
contributes only wiring: which endpoints to scrape, what to keep, where to
store it, and the dashboard that reads it. Consequently all stored metric
names are ecosystem-standard — community dashboards, alert-rule collections,
and a decade of operational lore apply to them directly.

When deployed via `fmx-instance`, `probes.targets` is populated from the
enabled components (`templates/monitoring.yaml`):

| Probe `instance` | URL | Condition |
|---|---|---|
| `fuego` | `<internalFhirBaseUrl>/$healthcheck` | `components.fuego.enabled` |
| `grafana` | `<internalGrafanaUrl>/api/health` | `components.grafana.enabled` |
| `keycloak` | `<internalKeycloakRealmUrl>` (realm endpoint) | `components.keycloak.enabled` |

All probes hit **internal cluster Services**, not the public FQDN — they test
component health, not ingress/TLS/DNS reachability from outside.

### The keep-list

`metrics.keepList` is a name-based allowlist applied in
`prometheus.relabel "keep"` **before** remote write. Everything not listed is
discarded and never stored. The default list contains exactly the 20 metric
names the dashboard consumes (see per-panel details below):

`up`, `probe_success`, `node_cpu_seconds_total`,
`node_memory_MemTotal_bytes`, `node_memory_MemAvailable_bytes`,
`node_filesystem_size_bytes`, `node_filesystem_avail_bytes`,
`container_cpu_usage_seconds_total`, `container_memory_working_set_bytes`,
`kubelet_volume_stats_capacity_bytes`, `kubelet_volume_stats_used_bytes`,
`kubelet_volume_stats_available_bytes`, `kube_pod_info`,
`kube_pod_status_phase`, `kube_pod_status_ready`,
`kube_pod_container_status_restarts_total`,
`traefik_entrypoint_requests_total`,
`traefik_entrypoint_request_duration_seconds_sum`,
`traefik_entrypoint_request_duration_seconds_count`,
`certmanager_certificate_expiration_timestamp_seconds`

Consequences:

- **New panels need a keep-list entry first.** History for a metric starts the
  moment its name is added — there is no backfill.
- KSM metrics additionally require the resource kind in
  `kubeStateMetrics.resources` (only `pods` by default).
- A second relabel rule drops cAdvisor series with `container=""`
  (pod-level aggregates) and `container="POD"` (pause containers) — no panel
  reads them, and they would roughly double cAdvisor storage.

## Panels

All panels use the `prometheus` datasource. Default time range: last 24h,
refresh 1m. The **Namespace** template variable
(`label_values(kube_pod_info, namespace)`, multi-select, All = `.+`) filters
the three top-10 workload panels (restarts by pod, container memory, container
CPU); all other panels are cluster-wide.

### Row 1 — Endpoint health (blackbox probes)

#### 1. Endpoint health (stat)

```promql
probe_success
```

- **Metric / job:** `probe_success` / `blackbox`. One series per probe target,
  `instance` = target name (fuego, grafana, keycloak).
- **Meaning:** result of the most recent HTTP probe. `1` (green "UP") = the
  endpoint answered 2xx within 5s; `0` (red "DOWN") = anything else (non-2xx,
  timeout, connection refused, DNS failure).
- **Interpretation:** a single DOWN sample can be a probe hiccup during a pod
  restart; sustained DOWN means the component is genuinely unreachable from
  inside the cluster. Shows "no probes" when `probes.targets` is empty.

#### 2. Endpoint uptime (24h) (stat)

```promql
100 * avg_over_time(probe_success[24h])
```

- **Meaning:** share of successful probes over the trailing 24h. At the 60s
  probe interval, one failed probe ≈ 0.07 percentage points.
- **Thresholds:** green ≥ 99.9% (≤ 1 failed probe/24h), orange ≥ 99%
  (≤ ~14 failed probes), red below.
- **Caveat:** the window is trailing — a resolved outage keeps depressing the
  number until it ages out of the 24h window.

#### 3. Endpoint status over time (timeseries)

```promql
probe_success
```

- **Meaning:** the same probe results as panel 1, drawn as a 0/1 step line per
  endpoint — shows *when* an endpoint was down and for how long.

### Row 2 — Node resources (node exporter)

#### 4. Node CPU usage (timeseries)

```promql
100 * (1 - avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[$__rate_interval])))
```

- **Metric / job:** `node_cpu_seconds_total` / `node` (counter of CPU-seconds
  per core and mode).
- **Meaning:** whole-node CPU utilization: 100 minus the average idle share
  across all cores. One line per node (`instance`).
- **Thresholds (line markers):** orange 80%, red 90%. Sustained > 90% on this
  single-node design means everything (including Postgres and the kubelet)
  is competing for CPU — the resource-starvation incident on the test box
  showed exactly this pattern before the resize.

#### 5. Node memory usage (timeseries)

```promql
100 * (1 - node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)
```

- **Metrics / job:** `node_memory_MemAvailable_bytes`,
  `node_memory_MemTotal_bytes` / `node`.
- **Meaning:** `MemAvailable` is the kernel's estimate of memory available for
  new workloads **without swapping** (free + reclaimable caches) — this is the
  correct signal, unlike `MemFree`, which is near zero on any healthy Linux
  box because of page-cache usage.
- **Thresholds:** orange 80%, red 90%. Sustained > 90% precedes OOM kills
  (Java components — Keycloak, HAPI — are the usual first victims).

#### 6. Root filesystem usage (timeseries)

```promql
100 * (1 - node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"})
```

- **Metrics / job:** `node_filesystem_avail_bytes`,
  `node_filesystem_size_bytes` / `node`. The exporter excludes
  pseudo-filesystems and container mounts
  (`/dev`, `/proc`, `/sys`, `/run`, `/var/lib/docker/*`, `/var/lib/kubelet/*`);
  the panel further filters to `mountpoint="/"`.
- **Meaning:** fill level of the node's root disk. On fmx-cluster installs
  **all persistent volumes live on this disk** (local-path-provisioner under
  `/opt/local-path-provisioner`), so this panel is the authoritative
  disk-capacity signal for the whole cluster.
- **Thresholds:** orange 75%, red 85%. Above ~85%, kubelet disk-pressure
  eviction and Prometheus' own size-based retention become concerns; a full
  root disk takes down Postgres, Loki, and the container runtime at once.
- **Note:** `avail_bytes` is space available to unprivileged users (excludes
  the ext4 root reserve), matching what `df` reports and what pods can
  actually use.

### Row 3 — Persistent volumes (kubelet)

#### 7. PVC usage (bar gauge)

```promql
100 * kubelet_volume_stats_used_bytes / kubelet_volume_stats_capacity_bytes
```

#### 8. PVC available space (timeseries)

```promql
kubelet_volume_stats_available_bytes
```

- **Metrics / job:** `kubelet_volume_stats_*` / `kubelet`. One series per
  bound PVC, labeled `namespace`/`persistentvolumeclaim`.
- **Meaning:** per-PVC fill level (panel 7, thresholds orange 75% / red 85%)
  and remaining bytes (panel 8). For local-path volumes, "capacity" is the
  size of the underlying filesystem, not the PVC's requested size — the
  request is not enforced.
- **KNOWN GAP (fixed for new volumes):** the kubelet only reports volume
  stats for volume plugins with metrics support — **`hostPath` volumes
  report nothing.** local-path-provisioner defaults to hostPath-type PVs,
  so installs provisioned that way show **"No data"** here while everything
  else works (`up{job="kubelet"} == 1` but zero `kubelet_volume_stats_*`
  series). The fmx-cluster playbook now sets the `defaultVolumeType: local`
  annotation on the `local-path` StorageClass, which makes the provisioner
  emit `local`-type PVs that do get stats (verified end-to-end on
  provisioner v0.0.32). The annotation only affects **newly provisioned**
  volumes: PVs created before the change stay hostPath and stay invisible
  here until their PVC is recreated. For such volumes, panel 6 (root
  filesystem) is the effective storage signal.

### Row 4 — Workload health (kube-state-metrics)

#### 9. Pods not ready (stat)

```promql
count(
  kube_pod_status_ready{condition="false"} == 1
  and on(namespace, pod) kube_pod_status_phase{phase=~"Running|Pending|Unknown"} == 1
) OR on() vector(0)
```

- **Metrics / job:** `kube_pod_status_ready`, `kube_pod_status_phase` /
  `kube-state-metrics`.
- **Meaning:** number of pods that are Running/Pending/Unknown but **not
  Ready**. The phase join excludes `Succeeded` pods (completed Jobs — the
  bootstrap job would otherwise count as "not ready" forever). The
  `OR on() vector(0)` makes an empty result render as a green `0` instead of
  "No data".
- **Thresholds:** green 0, red ≥ 1. Transient 1–2 during deployments/restarts
  is normal; a value that stays ≥ 1 means a pod is crash-looping, unschedulable,
  or failing its readiness probe.

#### 10. Container restarts (24h) (stat)

```promql
sum(increase(kube_pod_container_status_restarts_total[24h])) OR on() vector(0)
```

- **Metric / job:** `kube_pod_container_status_restarts_total` /
  `kube-state-metrics` (per-container restart counter).
- **Meaning:** total container restarts across the cluster in the trailing
  24h. Thresholds: green 0, orange ≥ 1, red ≥ 5.
- **Caveats:** trailing window — a red value can reflect an incident that is
  already over (check panel 11 for *when*). `increase()` extrapolates over
  counter resets, so the number is an estimate, not an exact count.

#### 11. Restarts by pod (1h, top 10) (timeseries)

```promql
topk(10, sum by (namespace, pod) (increase(kube_pod_container_status_restarts_total{namespace=~"$namespace"}[1h])))
```

- **Meaning:** which pods restarted, hour-granular. Filtered by the
  Namespace variable. A flat non-zero line = ongoing crash loop; a spike that
  returns to zero = a one-off (OOM kill, node reboot).

### Row 5 — Workload resources (cAdvisor)

#### 12. Container memory (working set, top 10) (timeseries)

```promql
topk(10, sum by (namespace, pod) (container_memory_working_set_bytes{container!="", namespace=~"$namespace"}))
```

- **Metric / job:** `container_memory_working_set_bytes` / `cadvisor`.
- **Meaning:** working-set memory per pod (summed over its containers) — the
  number the kubelet compares against memory limits for OOM decisions, i.e.
  memory that cannot be reclaimed without swapping. `container!=""` excludes
  pod-level aggregate series (defense in depth: the keep stage already drops
  them, together with `container="POD"` pause containers).
- **Interpretation:** on FMX installs the top consumers are expectedly
  Postgres, Keycloak, fuego/HAPI, and MinIO. Watch for a pod's line creeping
  toward its memory limit — that ends in an OOM kill (which then shows in
  panels 10/11).

#### 13. Container CPU usage (top 10) (timeseries)

```promql
topk(10, sum by (namespace, pod) (rate(container_cpu_usage_seconds_total{container!="", namespace=~"$namespace"}[$__rate_interval])))
```

- **Metric / job:** `container_cpu_usage_seconds_total` / `cadvisor`.
- **Meaning:** CPU cores consumed per pod (1.0 = one full core). Use together
  with panel 4: this tells you *who* is causing high node CPU.

### Row 6 — Ingress (Traefik)

Empty on clusters with `scrape.traefik.enabled: false`. Entrypoint-level
metrics: all traffic through Traefik's `web`/`websecure` entrypoints,
including redirects — not broken down per backend service.

#### 14. Ingress requests per second (timeseries)

```promql
sum by (code) (rate(traefik_entrypoint_requests_total[$__rate_interval]))
```

- **Metric / job:** `traefik_entrypoint_requests_total` / `traefik`.
- **Meaning:** request rate by HTTP status code class. Baseline traffic shape;
  a sudden spike in 401/403 or 404 is visible here before anyone reports it.

#### 15. Ingress 5xx error rate (stat)

```promql
(100 * sum(rate(traefik_entrypoint_requests_total{code=~"5.."}[5m]))
     / sum(rate(traefik_entrypoint_requests_total[5m])))
OR on() vector(0)
```

- **Meaning:** share of responses with a 5xx code over the last 5 minutes.
  Thresholds: green < 1%, orange ≥ 1%, red ≥ 5%. The `vector(0)` fallback
  covers the no-traffic case (0/0 would otherwise be "No data").
- **Interpretation:** 5xx at the ingress = a backend returned an error or was
  unreachable (Traefik itself emits 502/503/504 then). Correlate with panels
  1/3 to identify the failing component. Note: on a low-traffic cluster a
  handful of errors can dominate the percentage — check panel 14 for the
  absolute rate.

#### 16. Ingress request duration (avg) (timeseries)

```promql
sum(rate(traefik_entrypoint_request_duration_seconds_sum[$__rate_interval]))
/ sum(rate(traefik_entrypoint_request_duration_seconds_count[$__rate_interval]))
```

- **Metrics / job:** `traefik_entrypoint_request_duration_seconds_sum` /
  `_count` / `traefik`.
- **Meaning:** mean request latency across all ingress traffic. An **average**,
  not a percentile — the keep-list deliberately excludes the histogram buckets
  (they are by far the highest-cardinality Traefik series). A drifting average
  still catches "everything got slow" (e.g. Postgres under pressure); it will
  not catch a slow tail. Add
  `traefik_entrypoint_request_duration_seconds_bucket` to the keep-list if
  percentiles are ever needed.

### Row 7 — Certificates and self-monitoring

#### 17. Certificate expiry (stat)

```promql
min by (namespace, name) ((certmanager_certificate_expiration_timestamp_seconds - time()) / 86400)
```

- **Metric / job:** `certmanager_certificate_expiration_timestamp_seconds` /
  `cert-manager` (Unix timestamp of each certificate's notAfter).
- **Meaning:** days until expiry per Certificate resource (`min by` collapses
  duplicate series across cert-manager containers/restarts).
- **Thresholds:** green ≥ 30d, orange < 30d, red < 14d. Let's Encrypt certs
  renew at 30 days remaining, so **green is the only normal state** — orange
  means renewal is already overdue (ACME challenge failing, DNS/ingress
  problem); red is urgent. Shows "no certificates" when cert-manager manages
  none (e.g. TLS disabled).

#### 18. Scrape targets (stat)

```promql
min by (job) (up)
```

- **Metric:** `up` — synthesized by Alloy for every scrape, `1` = target
  answered, `0` = scrape failed. `min by (job)` collapses per-instance series
  (and multi-node duplicates) into one worst-case entry per job.
- **Meaning:** health of the monitoring pipeline itself. If any other panel
  looks wrong, check this one first: a DOWN job here means that panel's "No
  data" is a collection problem, not a workload problem. Expected entries:
  `node`, `kubelet`, `cadvisor`, `kube-state-metrics`, `traefik`,
  `cert-manager`, `blackbox`.
- **Caveat:** `up` only covers scrapes that fail — it cannot detect Alloy
  itself being down (then *all* panels go stale; the dashboard's data just
  stops at the failure time).

## Known limitations

- **PVC panels are empty on hostPath PVs** — see panel 7/8. Fixed in the
  fmx-cluster playbook via `defaultVolumeType: local`, but only for volumes
  provisioned after that change; pre-existing PVs stay invisible until
  recreated.
- **Single-node design:** on multi-node clusters, the cluster-level scrapes
  (kube-state-metrics, Traefik, cert-manager, blackbox) run once per Alloy
  pod, i.e. once per node, producing duplicate samples. Kubelet/cAdvisor
  scrapes are already node-local. Panel queries using `sum(...)` would
  overcount on multi-node; `min by (job) (up)` and the probe panels are safe.
- **Trailing windows:** panels 2 and 10 keep showing a resolved incident until
  it ages out of their 24h window.
- **No alerting:** the stack is dashboards-only; alert rules are a deliberate
  non-goal of this release.
- **History starts at enablement:** Prometheus retention is 10d / 4GB, and a
  metric's history begins when its name enters the keep-list.
