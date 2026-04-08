# DevOps Lab Handbook (Merged)

This is the merged handbook for the full Docker-based DevOps practice environment.

## 1. Overview

This is a local end-to-end lab with:
- Core app stack (Laravel + Nginx + PHP + MySQL + Redis + Queue)
- CI/CD (Gitea + Drone + local registry)
- Kubernetes (k3s + Portainer)
- IaC (Terraform + Ansible in containers)
- Observability (Prometheus + Grafana + Loki + exporters)

## 2. Architecture

### Core Runtime
- `docker-compose.yml` is the base stack.
- App HTTP endpoint: `http://localhost:8080`

### CI/CD
- `docker-compose.cicd.yml` starts Gitea, Drone, runner, registry.
- UIs:
  - Gitea: `http://localhost:3000`
  - Drone: `http://localhost:8081`

### Kubernetes
- `docker-compose.k8s.yml` starts k3s and Portainer.
- App via k8s NodePort: `http://localhost:30080`
- Portainer: `http://localhost:9000`

### IaC
- `docker-compose.iac.yml` provides one-off Terraform and Ansible execution.

### Monitoring
- `docker-compose.monitoring.yml` provides Prometheus, Grafana, Loki, Promtail, exporters.
- Prometheus: `http://localhost:9090`
- Grafana: `http://localhost:3001`

## 3. File And Folder Analysis (Condensed)

### Important Root Files
- `.drone.yml`: CI pipeline with composer/lint/test/build.
- `Dockerfile.php`: app image build; currently uses `php:8.4-fpm`.
- `docker-compose*.yml`: split by phase (core, cicd, k8s, monitoring, iac).
- `nginx.conf`: Laravel web routing + `stub_status` for exporter.
- `prometheus.yml`, `promtail.yml`: monitoring and logs.

### `k8s/`
- namespace, configmap, secret, deployment, services, registry mirror config.
- note: hardcoded DB/Redis IPs are brittle; prefer service names.

### `terraform/`
- provider + network + volumes + mysql/redis containers + outputs + state.

### `ansible/`
- inventory and app maintenance playbook (`site.yml`).

## 4. First Run

Run from project root (root project directory):

```bash
docker compose -f docker-compose.yml build --no-cache
docker compose -f docker-compose.yml up -d
docker compose -f docker-compose.yml ps
curl -I http://localhost:8080
```

## 5. Daily Workflow

### CI/CD day
```bash
docker compose -f docker-compose.yml -f docker-compose.cicd.yml up -d
```

### Kubernetes day
```bash
docker compose -f docker-compose.cicd.yml down
docker compose -f docker-compose.yml -f docker-compose.k8s.yml up -d
kubectl get nodes
```

### IaC day
```bash
docker compose -f docker-compose.iac.yml run --rm terraform init
docker compose -f docker-compose.iac.yml run --rm terraform plan
docker compose -f docker-compose.iac.yml run --rm terraform apply -auto-approve
docker compose -f docker-compose.iac.yml run --rm ansible site.yml
```

### Monitoring day
```bash
docker compose -f docker-compose.yml -f docker-compose.monitoring.yml up -d
```

## 6. Troubleshooting

### Build error: lock requires PHP >= 8.4 but build shows 8.2

```bash
grep '^FROM' Dockerfile.php
docker compose -f docker-compose.yml config | grep -A4 'build:'
docker compose -f docker-compose.yml build --no-cache
```

If 8.2 still appears, command is being run from wrong path or wrong compose project.

### Dubious ownership in git
Already handled in Dockerfile:
```Dockerfile
RUN git config --global --add safe.directory '*'
```

### Promtail logs not visible
Add Docker socket mount in promtail service:
```yaml
- /var/run/docker.sock:/var/run/docker.sock:ro
```

### Orphan container warning
Not fatal. Optional cleanup:
```bash
docker compose -f docker-compose.yml down --remove-orphans
```

## 7. Command Cheat Sheet

### Core
```bash
docker compose -f docker-compose.yml up -d
docker compose -f docker-compose.yml ps
docker compose -f docker-compose.yml logs -f php
```

### Cleanup
```bash
docker compose -f docker-compose.yml down
docker compose -f docker-compose.cicd.yml down
docker compose -f docker-compose.k8s.yml down
docker compose -f docker-compose.monitoring.yml down
```
