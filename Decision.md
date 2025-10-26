DECISION.md – Blue/Green Deployment with Nginx

Author: Yemisi Okunrounmu
Role: DevOps Intern

1. Objective

To implement a Blue/Green deployment pattern for Node.js services behind Nginx, achieving:

Zero-downtime environment switching

Auto-failover to the backup environment

Manual toggle capability

Transparent header forwarding for client verification

2. Design Decisions
a) Environment Switching

Implemented manual switching via switch.sh (Linux/macOS) and switch.ps1 (Windows).

Active environment is controlled by .env variable ACTIVE_POOL (blue or green).

Rollback scripts (rollback.sh / rollback.ps1) restore the previous active environment.

b) Auto-Failover

Configured in Nginx upstreams:

Primary upstream = active environment (Blue by default)

Backup upstream = inactive environment (Green by default)

max_fails and fail_timeout set low to detect failures quickly

proxy_next_upstream retries on timeout or 5xx response

This ensures zero failed client requests if the active environment goes down.

c) Docker Compose

Multi-service orchestration via docker-compose.yml

Services exposed on:

Blue: 8081

Green: 8082

Nginx public endpoint: 8080

Environment variables passed through .env:

BLUE_IMAGE, GREEN_IMAGE → container images

ACTIVE_POOL → controls Nginx template

RELEASE_ID_BLUE, RELEASE_ID_GREEN → ensures headers are unique per release

d) Nginx Template

Used nginx.conf.template and envsubst to dynamically populate PRIMARY_HOST and BACKUP_HOST.

Headers (X-App-Pool, X-Release-Id) preserved to allow grader/client validation.

Supports nginx -s reload for switching environments without downtime.

e) Scripts & Automation

switch.sh / switch.ps1:

Update .env ACTIVE_POOL variable

Reload Nginx configuration

Print active environment confirmation

rollback.sh / rollback.ps1:

Revert ACTIVE_POOL to previous environment

Reload Nginx

Scripts allow both manual toggle and automated verification.

3. Key Constraints & Solutions
Constraint	Solution
Zero downtime during switching	Nginx upstreams with primary/backup and reload
Fast failure detection	Low max_fails + short fail_timeout
Preserve headers	Configured Nginx to forward all upstream headers unchanged
Use Docker Compose only	No Kubernetes, no swarm, only Docker Compose
Direct traffic via Nginx	All requests go through Nginx, apps never exposed directly (except for chaos testing)
4. Lessons Learned

Dynamic Nginx templates with envsubst simplify Blue/Green toggling.

Failover testing is essential—simulated downtime via /chaos/start ensures resilience.

Separation of concerns: Nginx handles routing and failover, apps remain simple.

Cross-platform scripting ensures Windows and Linux users can switch environments seamlessly.

5. Optional Enhancements

Add CI/CD pipeline for automatic switching on successful builds.

Implement metrics & monitoring for environment health (Prometheus/Grafana).

Extend to multi-service architecture for larger applications.