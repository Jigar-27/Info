# Troubleshooting Playbook

## T-01: Build fails with `symfony/css-selector requires php >=8.4`

### Symptom
`composer install` fails during image build and logs show `php version (8.2.x) does not satisfy >=8.4`.

### Why
- `composer.lock` now expects PHP 8.4.
- Build is still using old PHP base image, or wrong Dockerfile path/context.

### Fix
```bash
# 1) Confirm Dockerfile base image
grep '^FROM' Dockerfile.php

# 2) Verify compose resolves correct file
docker compose -f docker-compose.yml config | grep -A4 'build:'

# 3) Rebuild without cache
docker compose -f docker-compose.yml build --no-cache
```

If still 8.2 appears, the command is likely running from the wrong folder. Run from project root.

## T-02: `fatal: detected dubious ownership in repository`

### Why
Git inside container does not trust mounted path owner.

### Fix
Already handled in `Dockerfile.php`:
```Dockerfile
RUN git config --global --add safe.directory '*'
```
Rebuild image after editing Dockerfile.

## T-03: Drone login redirects to wrong host (`gitea:3000` or stale IP)

### Why
External URL and internal URL mismatch.

### Fix
Keep these aligned in `docker-compose.cicd.yml`:
- `GITEA__server__ROOT_URL`
- `GITEA__server__DOMAIN`
- `DRONE_GITEA_SERVER`
- `DRONE_SERVER_HOST`

Use one stable host (`localhost` or a LAN IP) consistently.

## T-04: Monitoring targets are DOWN

### Why
Current `prometheus.yml` scrapes endpoints that may not expose metrics directly.

### Fixes
- For nginx: use `nginx-exporter:9113/metrics` instead of nginx port 80.
- For redis/mysql: scrape exporter containers, not raw DB ports.
- For php: use php-fpm exporter target if configured.

## T-05: Promtail shows no logs in Grafana

### Why
Promtail uses Docker service discovery but socket may not be mounted.

### Fix
In `docker-compose.monitoring.yml`, promtail service should include:
```yaml
volumes:
  - /var/run/docker.sock:/var/run/docker.sock:ro
  - /var/lib/docker/containers:/var/lib/docker/containers:ro
  - ./promtail.yml:/etc/promtail/config.yml
```
Then restart monitoring stack.

## T-06: K8s app works one day, breaks next day (DB/Redis)

### Why
`k8s/configmap.yml` uses hardcoded Docker IPs (`172.19.0.x`) which can change.

### Fix
Prefer stable service names or dedicated k8s services for DB/Redis.

## T-07: Orphan container warning in compose

### Symptom
`Found orphan containers (...)`

### Meaning
Not an error. Old containers from a previous compose project name are still present.

### Optional cleanup
```bash
docker compose -f docker-compose.yml down --remove-orphans
```

## T-08: 502 Bad Gateway in K8s (Nginx + PHP-FPM Sidecar)

### Symptom
Nginx returns a 502 Bad Gateway error when accessing the Laravel application in Kubernetes.

### Why
In a sidecar pattern (where Nginx and PHP are in the same pod), Nginx might be trying to communicate with an external service name instead of the local PHP container over localhost.

### Fix
Update the Nginx ConfigMap (`nginx.conf` or `default.conf`) to point `fastcgi_pass` to localhost. Do NOT point to a service name like `app:9000`:
```nginx
fastcgi_pass 127.0.0.1:9000;
```
Then apply the ConfigMap and restart the deployment.

## T-09: 404 Not Found for CSS/JS Assets in K8s

### Symptom
The Laravel site loads, but the CSS, javascript, or theme files (like Metronic) return 404 Not Found. "File not found" may also appear if index.php is missing.

### Why
When running Nginx and PHP as sidecars, Nginx might not have the static code files in its container. They need to be shared between the containers.

### Fix
Use an `initContainer` with a shared `emptyDir` volume to copy the application code so both Nginx and PHP containers can access it.
```yaml
      initContainers:
        - name: install-code
          image: devops-vms-app:v1
          command: ["cp", "-rp", "/var/www/.", "/shared/"]
          volumeMounts:
            - name: shared-assets
              mountPath: /shared
```
And make sure both main containers (Nginx and PHP) mount this `shared-assets` volume.

## T-10: Prometheus Graph Shows "Empty query result" or "Out of Sync"

### Symptom
Metrics are not appearing in Prometheus UI ("Empty query result"), and a red warning states that "Server time is out of sync."

### Why
Prometheus is extremely sensitive to time drift. If the server or VM clock and the browser have a time difference of more than ~30 seconds, Prometheus rejects the data as being from the "future" or "past."

### Fix
Force sync the time on the server (e.g., Ubuntu VM):
```bash
sudo apt-get update && sudo apt-get install -y ntpdate
# Force time sync against Google NTP
sudo ntpdate -u time.google.com
# Or explicitly set it if blocked: sudo date -s "YYYY-MM-DD HH:MM:SS"
```
After the time is corrected, it is required to restart Prometheus to start a valid scrape cycle:
```bash
kubectl rollout restart deployment prometheus
```
