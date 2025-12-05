Technical Challenges I Faced & How I Solved Them
This document lists the real issues I encountered during the 8byte DevOps assignment and how each was resolved — explained in a clear, human-friendly way.
Terraform: RDS Identifier Error
Challenge: Terraform threw an error because the RDS identifier must start with a letter, but my project name started with a number.
Fix: Updated the identifier format to always begin with a letter (e.g., prefixed with app- or similar). After the change, the RDS instance was created successfully.
Terraform: Unsupported PostgreSQL Version
Challenge: Terraform failed to create the RDS instance because the chosen PostgreSQL version wasn’t available in my selected AWS region.
Fix: Switched to a widely supported major version (e.g., 15.x or 16.x) that exists in all regions. Apply succeeded immediately afterward.
GitHub Actions: Secrets Not Recognized in if-condition
Challenge: Workflow failed with “unrecognized secrets context” when using secrets directly inside an if: statement.
Fix: Rewrote the condition using the correct ${{ secrets.MY_SECRET }} syntax inside env or proper expression format. Slack notifications started working again.
GitHub Actions: Dockerfile Not Found
Challenge: Docker build step couldn’t find the Dockerfile because it was inside the application/ directory, but the job was looking in the repository root.
Fix: Set working-directory: application for the build steps (or used proper path in docker/build-push-action). Build succeeded on the next run.
Trivy Scan Detecting High/Critical Vulnerabilities
Challenge: CI pipeline was blocked because Trivy found high-severity vulnerabilities in Node.js dependencies.
Fix: Updated vulnerable packages to latest secure versions, deleted node_modules and package-lock.json, then ran a clean npm install. Scan passed with zero high/critical issues.
Git Push Rejected (Non-Fast-Forward)
Challenge: git push was rejected because my branch was behind main and histories diverged.
Fix: Ran git fetch && git rebase origin/main, resolved any conflicts, then force-pushed with git push --force-with-lease. Push succeeded and history stayed clean.
EC2 Deployment Failed Due to Old Container Running
Challenge: New container wouldn’t start because an older version was still running and occupying the same port/name.
Fix: Added commands to the deployment script to docker stop and docker rm the old container (or used docker run --rm) before starting the new one. Deployments became reliable.
Monitoring Stack: Docker Desktop Not Running
Challenge: Local monitoring stack (Prometheus/Loki/Grafana) failed to start because Docker Desktop wasn’t running.
Fix: Started Docker Desktop, waited for the engine to be fully ready, then re-ran docker compose up. All services came online without issues.
Promtail Logs Not Appearing in Grafana
Challenge: No logs were visible in Grafana’s Explore view even though Promtail was running.
Fix: Confirmed Loki was added as a data source, checked Promtail config and logs to verify it was scraping the correct paths, then restarted both services. Logs started flowing correctly.
Testing the Application Through the ALB
Challenge: Wasn’t sure if the application was properly reachable behind the AWS Application Load Balancer.
Fix: Tested the ALB DNS name with:

Main endpoint (/)
Health check endpoint (/health)
Metrics endpoint (/metrics)

All returned expected 200 responses with correct content → deployment confirmed successful.
