# DevOps Lab Guide (Docker-Only)

## What This Folder Provides
- One place to run and practice **CI/CD, Kubernetes, IaC, and Monitoring**.
- Step-by-step commands for daily use.
- Troubleshooting for commonly encountered errors.

## Suggested Learning Flow
1. App stack (`docker-compose.yml`)
2. CI/CD (`docker-compose.cicd.yml` + `.drone.yml`)
3. Kubernetes (`docker-compose.k8s.yml` + `k8s/*`)
4. IaC (`docker-compose.iac.yml` + `terraform/*` + `ansible/*`)
5. Monitoring (`docker-compose.monitoring.yml` + Prometheus/Loki files)

## Read Next
1. `01-File-And-Folder-Analysis.md`
2. `02-First-Run-And-Daily-Workflow.md`
3. `03-Troubleshooting-Playbook.md`
4. `04-Commands-Cheat-Sheet.md`

## Important Note About Build Errors
If image builds fail because `composer.lock` requires `php >= 8.4` but the build resolves to 8.2.x, verify that the `Dockerfile.php` explicitly defines `FROM php:8.4-fpm`. For more details on this failure, see troubleshooting section `T-01`.
