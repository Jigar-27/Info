# DevOps Learning Book (All Modules, End-to-End)


## How To Read This Book

Use this in sequence:
1. Foundation: understand what each module solves.
2. Practice: run each module with daily workflow commands.
3. Operate: debug failures with intent, not trial-and-error.
4. Improve: add security, observability, and repeatability.

Following this order builds real DevOps habits, not just commands.

## Chapter 1: The Big Picture

The lab has five major modules:
- Core Application Runtime
- CI/CD Pipeline
- Kubernetes Runtime
- Infrastructure as Code (IaC)
- Monitoring and Logging

Think of it like a factory:
- Core runtime is the machine where the app runs.
- CI/CD is the assembly line that checks and ships changes.
- Kubernetes is the production floor scheduler.
- IaC is the blueprint that can rebuild the factory anytime.
- Monitoring is the control room and alarms.

## Chapter 2: Module 1 - Core Application Runtime

### Goal
Run Laravel locally with production-like services in containers.

### Files Involved
- `docker-compose.yml`
- `Dockerfile.php`
- `nginx.conf`

### Included Components
- `nginx`: HTTP entrypoint for app traffic.
- `php`: executes Laravel code.
- `mysql`: relational database.
- `redis`: cache/queue backend.
- `queue`: background jobs worker.

### Why This Module Matters
Without stable runtime, every other module becomes noisy. CI tests fail, k8s deploy fails, and monitoring shows chaos. This is the ground truth.

### Daily Use
```bash
docker compose -f docker-compose.yml up -d
docker compose -f docker-compose.yml ps
docker compose -f docker-compose.yml logs -f php
```

### Common Failure Patterns
- Build mismatch (PHP version vs `composer.lock`)
- Wrong working directory when invoking compose
- Bad env variables for DB/Redis host

## Chapter 3: Module 2 - CI/CD Pipeline

### Goal
Automatically validate and package the code whenever changes happen.

### Files Involved
- `.drone.yml`
- `docker-compose.cicd.yml`

### Stack
- Gitea: local Git service
- Drone: pipeline orchestrator
- Drone runner: executes jobs
- Registry: stores built images

### CI/CD Lifecycle
1. Push code.
2. Install dependencies.
3. Lint and test.
4. Build image.
5. Push image to registry.

### Why This Module Matters
This module protects quality. It prevents broken code from becoming deployable artifacts.

### Skills Covered
- Pipeline design
- Build reproducibility
- Artifact versioning
- Failure-first debugging

## Chapter 4: Module 3 - Kubernetes Runtime

### Goal
Run the app in orchestrated workloads (pods, deployments, services).

### Files Involved
- `docker-compose.k8s.yml`
- `k8s/namespace.yml`
- `k8s/configmap.yml`
- `k8s/secret.yml`
- `k8s/deployment.yml`
- `k8s/service.yml`
- `k8s/registries.yaml`

### Core Concepts
- Desired state vs imperative actions
- Rolling updates and rollback behavior
- Service exposure with NodePort
- App config vs app secrets separation

### Why This Module Matters
Kubernetes teaches operations discipline: declarative configs, rollout strategy, and fault isolation.

### Practical Commands
```bash
kubectl get all -n laravel
kubectl rollout status deployment/laravel -n laravel
kubectl rollout undo deployment/laravel -n laravel
kubectl logs -n laravel -l app=laravel -c php
```

## Chapter 5: Module 4 - Infrastructure as Code (IaC)

### Goal
Manage infrastructure with versioned code, not manual clicking.

### Files Involved
- `docker-compose.iac.yml`
- `terraform/*.tf`
- `ansible/ansible.cfg`
- `ansible/inventory.yml`
- `ansible/site.yml`

### Terraform Role
Creates and tracks infrastructure resources (networks, volumes, containers).

### Ansible Role
Configures running systems (checks, migrations, cache clear, optimization).

### Why This Module Matters
IaC is the backbone of reproducibility. If one can destroy and recreate reliably, the system is dependable.

### Practical Loop
```bash
docker compose -f docker-compose.iac.yml run --rm terraform plan
docker compose -f docker-compose.iac.yml run --rm terraform apply -auto-approve
docker compose -f docker-compose.iac.yml run --rm ansible site.yml
```

## Chapter 6: Module 5 - Monitoring and Logging

### Goal
Observe health, performance, and incidents before users complain.

### Files Involved
- `docker-compose.monitoring.yml`
- `prometheus.yml`
- `promtail.yml`

### Stack
- Prometheus: metrics storage and query
- Grafana: dashboards and visualization
- Loki: log aggregation
- Promtail: log shipping

### Why This Module Matters
If a problem is not visible, it cannot be fixed quickly. Monitoring converts unknown failures into visible signals.

### Signals to Track
- Availability (`up` style checks)
- Latency and error rates
- Resource usage trends
- App and container logs

## Chapter 7: Security Hygiene In This Lab

### Local-Lab Rules
- Keep secrets out of public repos.
- Never expose raw state files in docs portals.
- Redact sensitive values in examples.

### In The Portal
- Sensitive keys are redacted before render/copy/download.
- `terraform.tfstate` is excluded from browsing list.

### Production Reminder
Local convenience patterns (plain text secrets, insecure flags, host-level access) are learning shortcuts, not production defaults.

## Chapter 8: Practical Learning Roadmap (7 Sessions)

### Session 1 - Runtime Confidence
Bring up core stack, verify app, logs, and DB connectivity.

### Session 2 - Pipeline Confidence
Break a test intentionally, confirm pipeline blocks merge/deploy behavior.

### Session 3 - Container Delivery Confidence
Produce image tags and verify registry content after pipeline run.

### Session 4 - Kubernetes Confidence
Deploy to k8s, scale replicas, perform rollback.

### Session 5 - IaC Confidence
Destroy and recreate infra, then reconfigure with Ansible.

### Session 6 - Observability Confidence
Create one dashboard and one alert rule; simulate fault and verify detection.

### Session 7 - Capstone
Change code -> pipeline builds -> deploy runtime -> verify through dashboards/logs.

## Chapter 9: Fast Troubleshooting Map

### If app is down
- Check `docker compose ps`
- Check app logs (`php`, `nginx`, `mysql`)

### If pipeline fails
- Inspect failing step in Drone logs
- Confirm runner/registry reachability

### If k8s deploy fails
- `kubectl describe pod`
- `kubectl logs` for container-specific errors

### If metrics/logs empty
- Verify monitoring stack services
- Check scrape targets and promtail source paths

## Chapter 10: What Good Progress Looks Like

Signs of progress:
- Ability to explain each module’s role in one sentence.
- Ability to reproduce the stack from scratch.
- Ability to diagnose failures without random trial-and-error.
- Ability to make one safe improvement at a time.

## Appendix: High-Value Commands

```bash
# Core runtime
docker compose -f docker-compose.yml up -d

# CI/CD
docker compose -f docker-compose.yml -f docker-compose.cicd.yml up -d

# Kubernetes
docker compose -f docker-compose.yml -f docker-compose.k8s.yml up -d

# IaC
docker compose -f docker-compose.iac.yml run --rm terraform apply -auto-approve

# Monitoring
docker compose -f docker-compose.yml -f docker-compose.monitoring.yml up -d
```

## Closing Note

This represents system thinking, not just tool usage:
- Build correctly
- Ship safely
- Observe continuously
- Recover quickly

That is DevOps maturity.
