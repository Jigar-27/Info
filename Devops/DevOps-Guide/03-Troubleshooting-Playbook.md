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
grep '^FROM' devops/Dockerfile.php

# 2) Verify compose resolves correct file
docker compose -f devops/docker-compose.yml config | grep -A4 'build:'

# 3) Rebuild without cache
docker compose -f devops/docker-compose.yml build --no-cache
```

If still 8.2 appears, you are likely running from wrong folder. Run from project root.

## T-02: `fatal: detected dubious ownership in repository`

### Why
Git inside container does not trust mounted path owner.

### Fix
Already handled in your `Dockerfile.php`:
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

Use one stable host (`localhost` or your LAN IP) consistently.

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
docker compose -f devops/docker-compose.yml down --remove-orphans
```
