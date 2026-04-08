# Commands Cheat Sheet

## Core
```bash
docker compose -f docker-compose.yml up -d
docker compose -f docker-compose.yml ps
docker compose -f docker-compose.yml logs -f php
```

## CI/CD
```bash
docker compose -f docker-compose.yml -f docker-compose.cicd.yml up -d
docker compose -f docker-compose.yml -f docker-compose.cicd.yml ps
curl http://localhost:5050/v2/_catalog
```

## Kubernetes
```bash
docker compose -f docker-compose.yml -f docker-compose.k8s.yml up -d
kubectl get nodes
kubectl apply -f k8s/namespace.yml
kubectl apply -f k8s/configmap.yml
kubectl apply -f k8s/secret.yml
kubectl apply -f k8s/deployment.yml
kubectl apply -f k8s/service.yml
kubectl get all -n laravel
```

## IaC
```bash
docker compose -f docker-compose.iac.yml run --rm terraform init
docker compose -f docker-compose.iac.yml run --rm terraform plan
docker compose -f docker-compose.iac.yml run --rm terraform apply -auto-approve
docker compose -f docker-compose.iac.yml run --rm terraform state list
docker compose -f docker-compose.iac.yml run --rm ansible site.yml
```

## Monitoring
```bash
docker compose -f docker-compose.yml -f docker-compose.monitoring.yml up -d
docker compose -f docker-compose.yml -f docker-compose.monitoring.yml ps
```

## Cleanup
```bash
docker compose -f docker-compose.yml down
docker compose -f docker-compose.cicd.yml down
docker compose -f docker-compose.k8s.yml down
docker compose -f docker-compose.monitoring.yml down
docker system df
```
