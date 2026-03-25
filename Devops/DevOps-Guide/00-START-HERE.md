# DevOps Lab Guide (Docker-Only)

This guide documents your current setup in:
`/Users/jigar/Main/Info/Devops`

## What This Folder Gives You
- One place to run and practice **CI/CD, Kubernetes, IaC, and Monitoring**.
- Step-by-step commands for daily use.
- Troubleshooting for the exact errors you already hit.

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

## Important Note About Your Build Error
You had this failure:
- Composer lock requires `php >= 8.4`
- Build used `php 8.2.30`

Your current `Dockerfile.php` in this folder already uses `FROM php:8.4-fpm`, which is correct.
If you still see 8.2 in builds, see troubleshooting section `T-01`.
