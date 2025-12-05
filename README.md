This repo contains my work for the 8byte DevOps Engineer assignment.

The assignment mainly covers:

Creating AWS infrastructure using Terraform (VPC, subnets, ALB, EC2, RDS).

Building a simple Node.js app, containerizing it with Docker.

Setting up CI/CD with GitHub Actions (run tests, scan code, build & push Docker image, deploy to EC2).

Adding a small monitoring + logging setup using Prometheus, Grafana, Loki, and Promtail.

.
├── app/                     
│   ├── src/
│   ├── tests/
│   ├── package.json
│   ├── package-lock.json
│   └── Dockerfile            # Node.js application
│
├── infra/                   
│   ├── main.tf
│   ├── vpc.tf
│   ├── alb.tf
│   ├── ec2.tf
│   ├── rds.tf
│   ├── variables.tf
│   └── outputs.tf            # Terraform code for AWS resources
│
├── monitoring/              
│   ├── docker-compose.yml
│   ├── prometheus.yml
│   └── promtail-config.yml   # Local monitoring & logging stack
│
├── .github/
│   └── workflows/
│       └── ci-cd.yml         # GitHub Actions CI/CD pipeline
│
├── README.md                 # Main documentation
└── CHALLENGES.md             # Issues I faced + fixes




2. Application Overview

A very small Node.js/Express API is used to demonstrate the pipeline:

GET / – returns a basic JSON payload with status and a message.

GET /health – returns OK for health checks (used by ALB/monitoring).

GET /metrics – exposes Prometheus-formatted metrics using prom-client.

<img width="1336" height="554" alt="image" src="https://github.com/user-attachments/assets/5e5be75f-7fe2-4d6b-8004-99c5631ff3c2" />


3. Infrastructure (Terraform)

Terraform is used to provision the required AWS resources:

VPC with public + private subnets.

Internet Gateway / routing for public subnets.

Application Load Balancer  for HTTP traffic on port 80.

EC2 instance where the Dockerized app runs.

RDS PostgreSQL instance in private subnets.

Security Groups for ALB, EC2, and RDS.

<img width="1341" height="374" alt="image" src="https://github.com/user-attachments/assets/0c0c5a6d-7aae-4cde-9232-3dd8d0b3d540" />


4. CI/CD Pipeline (GitHub Actions – .github/workflows/ci-cd.yml)

The CI/CD pipeline is implemented using GitHub Actions and covers:

Pull Requests → main

Run tests only (pr-tests).

Pushes to main

Full CI/CD: build, scan, push Docker, deploy to staging, manual approval for production.

<img width="1284" height="622" alt="image" src="https://github.com/user-attachments/assets/5550add9-b065-4ac9-98bb-fa798c9f55dc" />

Jobs Overview:

1. pr-tests (CI on PR):

   The pr-tests job runs only when someone opens a pull request. It checks out the code, installs Node.js dependencies, and runs the test.

2. build_and_push (Main branch CI):

   The build_and_push job runs whenever code is pushed to the main branch. It installs dependencies, runs tests, performs a security         check. Also builds docker images.

   <img width="1290" height="609" alt="image" src="https://github.com/user-attachments/assets/e4c24a66-c6a8-46bb-80eb-2d5cdfe670b7" />

3. deploy_staging:

   It connects to the EC2 server using SSH, pulls the newest staging Docker image, stops any existing app container, and starts a fresh      one on port 80.

4. deploy_production (with manual approval):

   After staging deployment, the deploy_production job becomes available, but it won’t run until someone manually approves it in GitHub’s    production environment.

   <img width="1220" height="601" alt="image" src="https://github.com/user-attachments/assets/39b0dae8-3007-43fc-ab7e-fc60da5ea238" />

5. notify_failure:

   Finally, if anything goes wrong in the pipeline, the notify_failure job sends a Slack message

   <img width="1365" height="548" alt="image" src="https://github.com/user-attachments/assets/d205db86-2db0-40e7-8d89-b7949604f507" />


GitHub Secrets & Environment Configuration:

DOCKERHUB_USERNAME – Docker Hub username.

DOCKERHUB_TOKEN – Docker Hub access token/password.

EC2_HOST – Public IP or DNS of the EC2 instance.

EC2_USER – SSH user.

EC2_SSH_KEY – Private SSH key for EC2.

SLACK_WEBHOOK_URL – Incoming webhook for Slack failure notifications.


Verifying the Deployment:

Once I ran terraform apply and the main CI/CD pipeline has completed successfully, I checked whether everything is working. First, went into the infra folder and run terraform output alb_dns_name to get the DNS URL of the Application Load Balancer. After I have the ALB DNS, tested it from machine.


<img width="1102" height="135" alt="image" src="https://github.com/user-attachments/assets/d79c264b-8f33-4b98-a15e-13b84d540b92" />

Monitoring and Logging (Local Stack – monitoring/)

Monitoring and logging are implemented using a lightweight Docker Compose stack:

Prometheus – metrics collection and queries.

Grafana – metrics & logs visualization dashboards.

Loki – log aggregation backend.

Promtail – scrapes /var/log/*log on the host.

This stack runs locally on Docker to demonstrate how the application can be observed and debugged using open-source tools.

I Launched,

Prometheus on http://localhost:9090

Grafana on http://localhost:3001

Loki on http://localhost:3100

Promtail (shipping logs from /var/log/*log with job="varlog")

<img width="1112" height="495" alt="image" src="https://github.com/user-attachments/assets/b14bb73b-1ae3-4fd0-9a7c-660096b75a66" />


<img width="1119" height="582" alt="image" src="https://github.com/user-attachments/assets/4c587e11-99b4-477d-bc04-1a1a52051a38" />

Default login:

User: admin

Pass: admin 

Added Prometheus as a data source:

URL: http://prometheus:9090

Import a Node.js/Express dashboard  to visualize:

1. Request rate

2. Latencies

3. CPU & memory usage

4. Event loop lag









