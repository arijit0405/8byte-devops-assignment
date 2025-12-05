Markdown# Technical Challenges Faced & How I Solved Them

This document summarizes the real-world technical challenges I encountered during the **8byte DevOps Assignment** and the exact steps I took to resolve them. All issues and solutions reflect genuine debugging experience.

---

### 1. Terraform: RDS Identifier Must Start with a Letter

**Challenge**  
Terraform failed with:
Error: first character of "identifier" must be a letter
textMy `project_name` variable started with a number (e.g., `123project`), violating AWS RDS naming rules.

**Solution**  
Prefixed the identifier with a letter:
```hcl
identifier = "byte8-${var.project_name}-postgres"
RDS instance created successfully.

2. Terraform: PostgreSQL Version 16.4 Not Available
Challenge
textInvalidParameterCombination: Cannot find version 16.4 for postgres
The exact minor version wasn't available in my selected AWS region.
Solution
Used the major version instead:
hclengine_version = "16"
Allowed AWS to pick the latest patch in 16.x. Apply succeeded.

3. GitHub Actions: “Unrecognized named-value: secrets” in if Condition
Challenge
textUnrecognized named-value: 'secrets'
Occurred when using if: secrets.SLACK_WEBHOOK_URL != '' directly.
Solution
Wrapped in expression syntax:
YAMLif: ${{ secrets.SLACK_WEBHOOK_URL != '' }}
Slack notifications now trigger correctly.

4. Dockerfile Not Found During GitHub Actions Build
Challenge
textfailed to read dockerfile: open Dockerfile: no such file or directory
Workflow looked for Dockerfile in repo root, but it was inside /app.
Solution
Set working directory for build steps:
YAMLworking-directory: ${{ env.APP_DIR }}
Docker build now runs from the correct path.

5. Trivy Scan Failing Pipeline Due to HIGH Vulnerabilities
Challenge
Trivy reported HIGH severity vulnerabilities in Node.js dependencies → pipeline failed.
Solution
Fixed instead of bypassing:

Upgraded vulnerable packages (glob, cross-spawn, etc.)
Ran npm ci to respect package-lock.json

Result:
textTotal: 0 (HIGH: 0, CRITICAL: 0)
Pipeline passed with a clean scan.

6. Git Push Rejected – Non-Fast-Forward Error
Challenge
text! [rejected]        main -> main (non-fast-forward)
Caused by working on feature/metrics but accidentally pushing to main with outdated history.
Solution
Rebased correctly:
Bashgit checkout feature/metrics
git pull --rebase origin main
git push origin feature/metrics
Clean history, no force push needed.

7. EC2 Deployment: Old Container Blocking New Deployment
Challenge
New container failed to start because an old byte8-app container was still running.
Solution
Enhanced deploy script in GitHub Actions:
Bashif docker ps --format '{{.Names}}' | grep -q 'byte8-app'; then
    docker stop byte8-app
    docker rm byte8-app
fi
docker run -d --name byte8-app -p 3000:3000 <new-image>
Clean replacement on every deployment.

8. Monitoring Stack: Docker Desktop Not Running
Challenge
docker compose up -d failed with:
textcannot find dockerDesktopLinuxEngine
Solution
Started Docker Desktop, waited for the engine to be fully ready, then re-ran:
Bashdocker compose up -d
Prometheus, Grafana, Loki, and Promtail all started successfully.

9. Promtail Not Sending Logs to Grafana/Loki
Challenge
No logs appeared in Grafana Explore, even though Promtail container was running.
Root Causes

Loki data source not added in Grafana
Promtail wasn’t scraping /var/log/*.log

Solution

Added Loki as a data source in Grafana
Checked Promtail logs:Bashdocker logs promtail --tail 100
Fixed path in promtail-config.yml to correctly discover logs

Logs now visible with query:
text{job="varlog"}

10. Verifying Application Reachability Behind ALB
Challenge
Unsure whether the Node.js app was actually running and routed correctly via Application Load Balancer.
Solution
Tested directly using ALB DNS:
Bashcurl http://<alb-dns-name>/
curl http://<alb-dns-name>/health
curl http://<alb-dns-name>/metrics
All endpoints returned expected responses:

Main page served
{"status":"OK"} on /health
Prometheus metrics on /metrics
