# First Run And Daily Workflow

## 1) Start Core App
Run from the **project root** (the root project directory):

```bash
docker compose -f docker-compose.yml build --no-cache
docker compose -f docker-compose.yml up -d
docker compose -f docker-compose.yml ps
```

Check app:

```bash
curl -I http://localhost:8080
```

## 2) CI/CD Session

```bash
docker compose -f docker-compose.yml -f docker-compose.cicd.yml up -d
docker compose -f docker-compose.yml -f docker-compose.cicd.yml ps
```

UIs:
- Gitea: `http://localhost:3000`
- Drone: `http://localhost:8081`
- Registry: `http://localhost:5050/v2/_catalog`

## 3) Kubernetes Session
To save RAM, stop CI/CD first.

```bash
docker compose -f docker-compose.cicd.yml down
docker compose -f docker-compose.yml -f docker-compose.k8s.yml up -d
kubectl get nodes
```

App via k8s NodePort:
- `http://localhost:30080`

## 4) IaC Session

```bash
docker compose -f docker-compose.iac.yml run --rm terraform init
docker compose -f docker-compose.iac.yml run --rm terraform plan
docker compose -f docker-compose.iac.yml run --rm terraform apply -auto-approve
docker compose -f docker-compose.iac.yml run --rm ansible site.yml
```

## 5) Monitoring Session

```bash
docker compose -f docker-compose.yml -f docker-compose.monitoring.yml up -d
```

UIs:
- Prometheus: `http://localhost:9090`
- Grafana: `http://localhost:3001`
- Loki API: `http://localhost:3100`

## Recommended RAM Pattern (8GB)
- Run only one heavy phase at a time.
- Keep core app running.
- Stop unused stacks with `down`.
