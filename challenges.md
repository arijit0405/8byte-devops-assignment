# CHALLENGES.md – What Went Wrong & How I Fixed It

Real projects always hit bumps. Here’s what I ran into and how I solved each one quickly and cleanly.

1. **RDS Identifier Starting with a Number**  
   → AWS rejected it.  
   Fix: Prefixed the identifier with a letter. Done.

2. **PostgreSQL Version Not Available in My Region**  
   → Terraform kept failing.  
   Fix: Switched to a supported major version for the chosen region. Applied instantly.

3. **GitHub Actions Secrets in `if:` Conditions**  
   → Syntax error when using secrets directly in `if`.  
   Fix: Used `${{ secrets.MY_SECRET != '' }}` properly. Slack notifications worked again.

4. **Docker Build Couldn’t Find the Dockerfile**  
   → It was in `app/` not root.  
   Fix: Added `working-directory: ${{ env.APP_DIR }}` to the job. Build passed.

5. **Trivy Failing on High/Critical Vulns**  
   → Pipeline was red because of outdated deps.  
   Fix: Upgraded vulnerable packages, ran `npm ci`, and Trivy went green.

6. **Git Push Rejected (non-fast-forward)**  
   → I was accidentally pushing to main while on a feature branch.  
   Fix: Rebassed with `git pull --rebase origin main` and pushed the right branch. History stayed clean.

7. **Deployments Failing Because Old Container Still Running**  
   → New container couldn’t start (port already in use).  
   Fix: Added `docker stop/rm byte8-app || true` before running the new one. Deployments now rock-solid.

8. **Monitoring Stack Wouldn’t Start**  
   → Docker Desktop wasn’t running.  
   Fix: Started Docker Desktop. `docker compose up -d` brought everything up perfectly.

9. **No Logs Showing in Grafana (Loki/Promtail)**  
   → Promtail was silent.  
   Fix: Checked Promtail container logs, confirmed paths, added Loki datasource again. Logs instantly appeared.

10. **“Is the App Really Behind the ALB?”**  
    → Wasn’t 100% sure traffic was routing correctly.  
    Fix: Curled the ALB DNS directly:  
    ```bash
    curl http://<alb-dns>/
    curl http://<alb-dns>/health
    curl http://<alb-dns>/metrics
