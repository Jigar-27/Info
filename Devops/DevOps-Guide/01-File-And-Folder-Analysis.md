# File And Folder Analysis

This is a practical analysis of every main file and folder in `/Users/jigar/Main/Info/Devops`.

## Top-Level Files

### `.drone.yml`
- Purpose: CI pipeline (install deps, lint, test, build/push image).
- Good: uses `php:8.4-cli` and Kaniko for build/push.
- Watch-out:
  - Uses hardcoded registry host `10.80.30.83:5050`.
  - If your IP changes, pipeline push will fail.

### `Dockerfile.php`
- Purpose: PHP-FPM app image for Laravel.
- Good:
  - `php:8.4-fpm` (matches lock requiring >=8.4).
  - Fixes git safe-directory issue.
  - Installs Redis extension and Composer.
- Watch-out:
  - `COPY . .` depends on correct build context.

### `docker-compose.yml`
- Purpose: core app stack (nginx, php, mysql, redis, queue).
- Good: network and service layout is clean.
- Watch-out:
  - Uses `context: ../` and `dockerfile: devops/Dockerfile.php`.
  - This assumes compose is run from project root where `devops/` is a child.

### `docker-compose.cicd.yml`
- Purpose: Gitea + Drone + runner + local registry.
- Good: includes admin user and runner socket mount.
- Watch-out:
  - Uses hardcoded IP `10.80.30.83` in Gitea/Drone env vars.
  - Registry is mapped as `5050:5000`, but some older docs use `5000`.

### `docker-compose.k8s.yml`
- Purpose: k3s and Portainer.
- Good: NodePort `30080` exposed directly.
- Watch-out:
  - k3s is privileged and can be heavy on 8GB if all stacks run together.

### `docker-compose.monitoring.yml`
- Purpose: Prometheus, Grafana, Loki, Promtail + exporters.
- Good: nice extension with nginx/mysql/redis/php-fpm exporters.
- Watch-out:
  - `promtail.yml` uses docker discovery but compose file currently does **not** mount `/var/run/docker.sock` for promtail.

### `docker-compose.iac.yml`
- Purpose: one-off Terraform and Ansible containers.
- Good: no host install required.
- Watch-out:
  - `network_mode: host` can behave differently on macOS Docker Desktop.

### `nginx.conf`
- Purpose: serves Laravel via PHP-FPM and exposes `/stub_status`.
- Good: includes `stub_status` for nginx exporter.

### `prometheus.yml`
- Purpose: scrape definitions.
- Watch-out:
  - Includes `cadvisor:8080`, but no cadvisor service in compose file.
  - `php:9000` with `/metrics` usually does not expose Prometheus metrics unless exporter/app instrumentation exists.

### `promtail.yml`
- Purpose: ship container logs to Loki.
- Watch-out:
  - Requires Docker socket for service discovery.

### `docs.html`, `handbook.html`
- Purpose: existing visual docs/handbook pages.
- Good: polished UI and organized sections.
- Watch-out:
  - These can drift from actual config quickly; keep markdown guide as source-of-truth.

### `.DS_Store`
- macOS metadata file. Safe to ignore.

## Folder: `k8s/`

### `namespace.yml`
- Creates namespace `laravel`.

### `configmap.yml`
- Injects app config.
- Watch-out: `DB_HOST` and `REDIS_HOST` are hardcoded container IPs (`172.19.0.x`), which are brittle.

### `secret.yml`
- Contains DB credentials and APP_KEY.
- Watch-out: committed plain-text secret values are okay for lab only.

### `deployment.yml`
- Two-container pod (`php` + `nginx`) with initContainer copying app files.
- Good: works for local lab.
- Watch-out:
  - `imagePullPolicy: Never` requires image to exist on k3s node runtime.

### `service.yml`
- ClusterIP + NodePort(30080) for access.

### `registries.yaml`
- registry mirror config for k3s.

## Folder: `terraform/`

### `main.tf`
- Defines Docker provider and version pin.

### `network.tf`
- Creates `terraform_app_network`.

### `volumes.tf`
- Creates redis/mysql volumes.

### `mysql.tf`, `redis.tf`
- Creates container resources with restart policy.

### `outputs.tf`
- Exposes IDs.

### `.terraform.lock.hcl`
- Provider lock file (good).

### `.terraform/`
- Local provider binaries/cache.

### `terraform.tfstate`
- Current infra state (contains resource details; do not expose publicly).

## Folder: `ansible/`

### `ansible.cfg`
- Inventory and defaults.

### `inventory.yml`
- Targets container `devops-php-1` using docker connection.

### `site.yml`
- Checks PHP/Laravel, runs migrations, clears cache, optimizes app.
- Good: executed successfully per your logs.

### `roles/`
- currently empty, ready for future role-based refactor.
