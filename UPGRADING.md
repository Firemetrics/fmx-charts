# Upgrading

## 2.0.x → 2.1.0

No action required.

## 1.20.x → 2.0.0

2.0.0 adds cluster monitoring: metrics in Prometheus and an "FMX Cluster
Health" dashboard in Grafana. The upgrade changes no data.

1. Update the playbooks in your installation directory. Download
   `firemetrics-installation-v2.1.0.zip`, unpack it somewhere else, and unpack
   only its `assets.zip` over your installation directory:

   ```sh
   cd /path/to/your/installation
   unzip -o /path/to/firemetrics-installation/assets.zip
   ```

   This replaces the playbooks, `templates/` and `group_vars/`, which also
   prepare Traefik and storage for monitoring. Your `inventories/` and
   `secrets/` are not in the package and stay as they are. Do not run
   `init.sh`, because it would generate new secrets. If you changed
   `group_vars/all.yaml`, apply your changes again.
2. In `inventories/main.yaml`, set `target_revision` to `"2.1.0"`. To turn
   monitoring on as well, add it under `values`. Then run `./deploy.sh`:

   ```yaml
   deployments:
     main:
       chart:
         target_revision: "2.1.0"
       values:
         components:
           monitoring:
             enabled: true
   ```

3. If Loki was enabled before, remove the old log collector once the upgrade
   has synced. Otherwise logs arrive twice:

   ```sh
   argocd app sync <instance>-loki --prune
   ```

## After every upgrade

Check that the database extension matches the new Firemetrics version:

```sh
kubectl -n <namespace> exec <instance>-postgres-0 -c postgres -- \
  psql -U postgres -d firemetrics -Atc "select extversion from pg_extension where extname = 'fhirql'"
```

If it still shows the old version, delete the `<instance>-bootstrap-*` job and
run `argocd app sync <instance>-bootstrap`.
