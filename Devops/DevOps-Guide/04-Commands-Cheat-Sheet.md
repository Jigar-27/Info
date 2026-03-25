# Commands Cheat Sheet

## Core
```bash
docker compose -f devops/docker-compose.yml up -d
docker compose -f devops/docker-compose.yml ps
docker compose -f devops/docker-compose.yml logs -f php
```

## CI/CD
```bash
docker compose -f devops/docker-compose.yml -f devops/docker-compose.cicd.yml up -d
docker compose -f devops/docker-compose.yml -f devops/docker-compose.cicd.yml ps
curl http://localhost:5050/v2/_catalog
```

## Kubernetes
```bash
docker compose -f devops/docker-compose.yml -f devops/docker-compose.k8s.yml up -d
kubectl get nodes
kubectl apply -f devops/k8s/namespace.yml
kubectl apply -f devops/k8s/configmap.yml
kubectl apply -f devops/k8s/secret.yml
kubectl apply -f devops/k8s/deployment.yml
kubectl apply -f devops/k8s/service.yml
kubectl get all -n laravel
```

## IaC
```bash
docker compose -f devops/docker-compose.iac.yml run --rm terraform init
docker compose -f devops/docker-compose.iac.yml run --rm terraform plan
docker compose -f devops/docker-compose.iac.yml run --rm terraform apply -auto-approve
docker compose -f devops/docker-compose.iac.yml run --rm terraform state list
docker compose -f devops/docker-compose.iac.yml run --rm ansible site.yml
```

## Monitoring
```bash
docker compose -f devops/docker-compose.yml -f devops/docker-compose.monitoring.yml up -d
docker compose -f devops/docker-compose.yml -f devops/docker-compose.monitoring.yml ps
```

## Cleanup
```bash
docker compose -f devops/docker-compose.yml down
docker compose -f devops/docker-compose.cicd.yml down
docker compose -f devops/docker-compose.k8s.yml down
docker compose -f devops/docker-compose.monitoring.yml down
docker system df
```
