Technical Challenges I Faced & How I Solved Them

This document lists the real issues I faced while completing the 8byte DevOps assignment and how I fixed each one. The explanations are simple, clear, and written in a human-friendly way.

Terraform: RDS Identifier Error

Challenge:
Terraform showed an error saying the RDS identifier must start with a letter. My project name began with a number, so AWS didn’t accept it.

Fix:
I updated the identifier format so that it always starts with a letter. After making this change, the RDS instance was created successfully.

Terraform: Unsupported PostgreSQL Version

Challenge:
Terraform failed to create the RDS instance because the PostgreSQL version I used wasn’t available in my AWS region.

Fix:
I switched to a stable major version that AWS supports everywhere. After updating the version, Terraform applied without issues.

GitHub Actions: Secrets Not Recognized

Challenge:
GitHub Actions gave an error saying it couldn’t recognize the secrets context when used directly inside an if-condition.

Fix:
I rewrote the condition using the proper GitHub expression format. This fixed the workflow and allowed Slack notifications to work correctly.

GitHub Actions: Dockerfile Not Found

Challenge:
The Docker build step kept failing because GitHub Actions was searching for the Dockerfile in the root folder, while mine was inside the application directory.

Fix:
I changed the working directory of the build steps so GitHub Actions points to the correct folder. After that, the Docker build worked properly.

Trivy Scan Detecting High Vulnerabilities

Challenge:
The Trivy scan stopped the CI pipeline because it found high-severity vulnerabilities in some Node.js dependencies.

Fix:
I updated the affected packages and reinstalled everything with a clean dependency setup. After the update, the security scan passed with no high or critical issues.

Git Push Rejected (Non-Fast-Forward)

Challenge:
My push was rejected because my branch was behind the main branch and the histories didn’t match.

Fix:
I rebased my branch with the latest changes from main and then pushed again. This resolved the conflict and cleaned up the commit history.

EC2 Deployment Failed Due to Old Container

Challenge:
The deployment kept failing because an older version of the container was still running on the EC2 instance.

Fix:
I added logic to stop and remove the old container before starting a new one. This ensured deployments always run the updated version.

Monitoring Stack: Docker Desktop Not Running

Challenge:
The monitoring stack failed to start locally because Docker Desktop wasn’t running.

Fix:
I opened Docker Desktop, waited for it to fully start, and then relaunched the stack. All services came up properly afterward.

Promtail Logs Not Showing in Grafana

Challenge:
Grafana’s Explore view didn’t show any logs coming from Promtail.

Fix:
I added Loki as a data source in Grafana, checked Promtail’s logs, and confirmed that it was reading from the expected log files. After rechecking everything, logs started appearing correctly.

Testing Through the ALB

Challenge:
I wasn’t sure whether the application was correctly deployed behind the AWS Application Load Balancer.

Fix:
I tested the ALB DNS by checking the main endpoint, the health endpoint, and the metrics endpoint. All responses came back correctly, confirming the deployment was successful.
