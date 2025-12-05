Technical Challenges I Faced & How I Solved Them

This document summarizes the real issues I encountered during the 8byte DevOps assignment and how I fixed each one. All explanations are written in a clear, simple, and human-friendly way.

1.  Terraform: RDS Identifier Error Challenge

Terraform returned an error saying:

“The RDS identifier must start with a letter.”

My project name started with a number, so AWS rejected the identifier.

Fix

I updated the identifier to always begin with a letter. After this change, the RDS instance was created successfully.

2.  Terraform: Unsupported PostgreSQL Version Challenge

Terraform failed with an error because the PostgreSQL version I used was not available in my AWS region.

Fix

I switched to a region-supported stable major version. After updating it, Terraform applied without any issues.

3.  GitHub Actions: Secrets Not Recognized in Conditions Challenge

GitHub Actions showed an error saying that the secrets context could not be used directly inside an if: condition.

Fix

I rewrote the condition using the proper GitHub expression syntax:

if: ${{ secrets.SLACK\_WEBHOOK\_URL != '' }}

This fixed the workflow and allowed Slack notifications to function correctly.

4.  GitHub Actions: Dockerfile Not Found Challenge

The Docker build step failed with:

“Dockerfile not found”

This happened because the workflow was searching for the Dockerfile in the root directory, but mine was inside the app/ folder.

Fix

I updated the workflow to set the correct working directory:

working-directory: ${{ env.APP\_DIR }}

After this update, the Docker image built successfully.

5.  Trivy Scan Detecting High Vulnerabilities Challenge

Trivy found high-severity vulnerabilities in Node.js packages, causing the CI pipeline to fail.

Fix

I upgraded the vulnerable packages and reinstalled dependencies cleanly (npm ci). After the updates, the Trivy scan passed with zero high or critical vulnerabilities.

6.  Git Push Rejected (Non-Fast-Forward) Challenge

My push to the repository was rejected with:

“non-fast-forward — remote contains changes you don’t have locally.”

This happened because I was working on a feature branch but pushing to main.

Fix

I rebased my branch with:

git pull --rebase origin main

Then pushed the correct branch:

git push origin feature/metrics

This resolved the conflict and kept the commit history clean.

7.  EC2 Deployment Failed Due to Running Old Container Challenge

The deployment via SSH kept failing because an older byte8-app container was still running on the EC2 instance.

Fix

I added logic in the GitHub Actions deploy script to stop and remove the old container before running the new one:

docker stop byte8-app docker rm byte8-app

After this, deployments worked consistently.

8.  Monitoring Stack: Docker Desktop Not Running Challenge

The monitoring stack (docker compose up -d) failed because Docker Desktop wasn’t running on my system.

Fix

I launched Docker Desktop, waited for it to initialize, and reran the command. The entire stack — Prometheus, Grafana, Loki, Promtail — started correctly.

9.  Promtail Logs Not Appearing in Grafana Challenge

Grafana Explore wasn’t showing any logs coming from Promtail.

Fix

I followed these steps:

Added Loki as a data source in Grafana.

Checked Promtail logs using:

docker logs promtail --tail 100

Verified that /var/log/\*log files were being scraped.

After confirming the config, logs started appearing in Grafana Explore.

10.  Application Testing Through the ALB Challenge

I was unsure whether the application was properly deployed behind the AWS Application Load Balancer.

Fix

I tested the endpoints using the ALB DNS:

curl http://<alb\_dns\_name>/ curl http://<alb\_dns\_name>/health curl http://<alb\_dns\_name>/metrics

All responses came back correctly, confirming the deployment was successful and the ALB was routing traffic properly.
