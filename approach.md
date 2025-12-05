# My DevOps Challenge – Approach & Solution

Here's how I tackled the assignment in a clean, realistic, and pragmatic way.

### 1. Planning First
I broke the task into 5 clear pillars:
- Terraform IaC (AWS)
- Node.js app + Docker
- GitHub Actions CI/CD
- Monitoring stack (Prometheus + Grafana + Loki)
- Solid documentation

### 2. Terraform – Production-like AWS Setup
Built a proper VPC layout:
- Public subnets → ALB + NAT
- Private subnets → EC2 + RDS (PostgreSQL)
- Least-privilege Security Groups
- Split config into logical files (vpc.tf, alb.tf, ec2.tf, rds.tf, etc.)

Tested with `terraform plan/apply` and verified ALB was reachable before moving on.

### 3. The Application
Simple but useful Node.js API with:
- `/` → hello message
- `/health` → 200 OK
- `/metrics` → Prometheus-format metrics (using prom-client)

Dockerfile based on `node:20-alpine`, using `npm ci` for reproducible builds.

### 4. GitHub Actions CI/CD
Two workflows:

**On PRs** (fast feedback):
- Install deps + run tests

**On push to main** (full pipeline):
1. Tests + npm audit
2. Build & Trivy scan Docker image
3. Push to Docker Hub
4. Deploy to staging EC2 (auto)
5. Manual approval gate → deploy to production EC2

Used `appleboy/ssh-action` to SSH into EC2, pull latest image, and restart the container behind the ALB.

### 5. Local Monitoring Stack (Docker Compose)
Ran everything locally to keep it simple and cost-free:
- Prometheus → scrapes `/metrics`
- Grafana → dashboards + Explore
- Loki + Promtail → log aggregation ({job="varlogs"} works perfectly)

### 6. Git Workflow
Feature branches → rebase → clean PRs → no force-pushes on main.

### 7. End-to-End Validation
- ALB serves the app
- CI/CD runs flawlessly
- Staging auto-deploys, production waits for my approval
- Metrics flow into Prometheus → visible in Grafana
- Logs appear in Loki

### Why This Approach?
It mirrors what I’d actually ship in a real job: secure infra, automated & safe deployments, proper observability, and clean docs — all without over-engineering.

Simple, reproducible, and production-ready for a single-service setup.

Thanks for the challenge — had fun building it! 🚀
