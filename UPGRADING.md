# Upgrading

## 1.20.x → next release (monitoring stack)

This release introduces the `fmx-monitoring` chart (metrics collection via
Alloy, a local Prometheus, kube-state-metrics, and the "FMX Cluster Health"
Grafana dashboard) and **moves the Alloy collector out of `fmx-loki`** into
`fmx-monitoring`. New values: `components.monitoring.*` (disabled by default).

### Required steps for installs with Loki enabled

The Alloy DaemonSet, ConfigMap, ServiceAccount, ClusterRole, and
ClusterRoleBinding previously managed by the `<instance>-loki` Application are
no longer part of the `fmx-loki` chart. Because child Applications sync with
`prune: false`, Argo CD will **not** delete the old resources — until they are
pruned, two Alloy DaemonSets run side by side and ship duplicate log lines to
Loki.

After the upgrade has synced, prune the orphaned resources once:

```sh
argocd app sync <instance>-loki --prune
```

or delete them manually (note the old ClusterRole/Binding name has no
namespace suffix):

```sh
kubectl -n <namespace> delete daemonset,configmap,serviceaccount -l 'app.kubernetes.io/component=alloy'
kubectl delete clusterrole,clusterrolebinding <instance>-loki-alloy
```

### Removed values

- `components.loki.alloy.image` — the Alloy image is now configured at
  `components.monitoring.alloy.image`. `components.loki.alloy.enabled` and
  `components.loki.alloy.config.*` remain and still control the log pipeline.

### Enabling monitoring on an existing install

1. Verify the Nexus registry mirror proxies the two new image paths
   (`prom/prometheus` from docker.io and
   `kube-state-metrics/kube-state-metrics` from registry.k8s.io) — the mirror
   is a wildcard pull-through, so this is a server-side Nexus check only.
2. For ingress traffic metrics, re-run the fmx-cluster infrastructure playbook
   (it now exposes Traefik's metrics service); or set
   `components.monitoring.scrape.traefik.enabled: false`.
3. Set `components.monitoring.enabled: true`.
4. The Grafana pod must restart to load the new Prometheus datasource —
   changing datasources does not restart it automatically. The image/values
   change of a regular chart upgrade does this as a side effect; otherwise:
   `kubectl -n <namespace> rollout restart deployment <instance>-grafana`.

### Known limitations

- Single-node design: on multi-node clusters, cluster-level scrapes
  (kube-state-metrics, Traefik, cert-manager, probes) run once per node and
  duplicate samples.
- The metric keep-list (`metrics.keepList` in fmx-monitoring) drops everything
  the shipped dashboard does not use. Add metric names to the list before
  building panels that need them; history starts at that moment.
