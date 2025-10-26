# 🌀 DevOps Intern Stage 2 – Blue/Green Deployment with Nginx Upstreams (Auto-Failover + Manual Toggle)

![Blue/Green Flowchart](assets/blue-green-flowchart.png)

This project implements a **Blue/Green deployment pattern** using **Docker Compose** and **Nginx upstreams** to achieve **zero-downtime deployments** with **manual environment switching** and **auto-failover** capability.

---

## 🎯 Objective
To simulate a production-style Blue/Green release setup that allows:
- Seamless switching between Blue and Green environments
- No downtime during deployments
- Auto-failover logic within Nginx configuration
- Environment toggle using shell or PowerShell scripts

---

## 🧩 Project Structure

blue-green-nginx/
│
├── blue/
│ └── Dockerfile
│ └── server.js
│
├── green/
│ └── Dockerfile
│ └── server.js
│
├── nginx/
│ └── nginx.conf.template
│
├── assets/
│ └── blue-green-flowchart.png
│
├── .env
├── .env.example
├── docker-compose.yml
├── switch.sh
├── rollback.sh
├── switch.ps1
├── rollback.ps1
├── README.md
└── DECISION.md

yaml
Copy code

---

## ⚙️ Technologies Used
- **Docker & Docker Compose** – Containerization & multi-service orchestration  
- **Node.js (v18-alpine)** – Lightweight backend for Blue/Green apps  
- **Nginx** – Reverse proxy & load balancer for Blue/Green routing  
- **Shell & PowerShell Scripts** – Environment toggle and rollback automation  

---

## 🐳 Docker Compose Overview

```yaml
services:
  nginx:
    image: nginx:1.25-alpine
    container_name: nginx
    env_file: .env
    ports:
      - "8080:80"
    volumes:
      - ./nginx/nginx.conf.template:/etc/nginx/nginx.conf.template:ro
    command: >
      /bin/sh -c "
      if [ \"$ACTIVE_POOL\" = \"green\" ]; then
        export PRIMARY_HOST=app_green:3000; export BACKUP_HOST=app_blue:3000;
      else
        export PRIMARY_HOST=app_blue:3000; export BACKUP_HOST=app_green:3000;
      fi;
      envsubst '$$PRIMARY_HOST $$BACKUP_HOST' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf &&
      nginx -g 'daemon off;'
      "

  app_blue:
    image: ${BLUE_IMAGE}
    env_file: .env
    environment:
      - RELEASE_ID=${RELEASE_ID_BLUE}
    ports:
      - "8081:3000"

  app_green:
    image: ${GREEN_IMAGE}
    env_file: .env
    environment:
      - RELEASE_ID=${RELEASE_ID_GREEN}
    ports:
      - "8082:3000"
⚡ Environment Variables (.env)
bash
Copy code
ACTIVE_POOL=blue
BLUE_IMAGE=blue-app:latest
GREEN_IMAGE=green-app:latest
RELEASE_ID_BLUE=1
RELEASE_ID_GREEN=1
🚀 Build and Run the Containers
bash
Copy code
# Build app images
docker build -t blue-app:latest ./blue
docker build -t green-app:latest ./green

# Start containers
docker compose up -d
🧪 Testing the Deployment
Check which environment is active
bash
Copy code
curl http://localhost:8080
Expected output:

mathematica
Copy code
💙 Blue App - Version 1
🌐 Optional: Expose Locally via Ngrok
If you want to test externally:

Start ngrok on port 8080 (Nginx public port):

bash
Copy code
ngrok http 8080
Copy the HTTPS forwarding URL (e.g., https://xxxx.ngrok-free.dev)

Use it to access the active app from any device/browser.

Note: Only one ngrok endpoint per account can be active at a time. Stop the previous session before starting a new one.

🔁 Switching Environments
Switch between Blue ↔ Green environments using:

For Linux/macOS:
bash
Copy code
./switch.sh
For Windows PowerShell:
powershell
Copy code
.\switch.ps1
Then verify:

bash
Copy code
curl http://localhost:8080
Expected output:

mathematica
Copy code
💚 Green App - Version 1
🧯 Rollback
If you need to revert to the previous environment:

Linux/macOS:
bash
Copy code
./rollback.sh
PowerShell:
powershell
Copy code
.\rollback.ps1
📁 Git Workflow / Pushing to GitHub
bash
Copy code
# Initialize Git repository (if not already)
git init

# Mark directory as safe (Windows only)
git config --global --add safe.directory C:/Users/banji/projects/blue-green-nginx

# Stage all files
git add .

# Commit changes
git commit -m "Initial commit: Blue/Green Switch project by Yemisi Okunrounmu (DevOps Intern)"

# Add GitHub remote
git remote add origin https://github.com/Yemmmyc/blue-green-nginx.git

# Push to GitHub (main branch)
git branch -M main
git push -u origin main
📈 Flow Summary
Blue is active – users see Blue App responses.

Deploy new release to Green.

Switch traffic using switch.sh / switch.ps1.

Validate Green is working correctly.

Rollback if needed using rollback scripts.

✅ Final Checklist Before Submission
Include in your repo:

README.md → Blue/Green deployment instructions

.env.example → Environment variables template

docker-compose.yml → Compose orchestration

nginx/nginx.conf.template → Nginx template

switch.sh / switch.ps1 → Manual environment switch

rollback.sh / rollback.ps1 → Rollback scripts

DECISION.md → Your reasoning for Part A

PartB_Backend_im_Research.md (or Google Doc link) → Research task

👩‍💻 Author
Yemisi Okunrounmu
DevOps Intern
📧 Email: yemmmyc@hotmail.com
🌐 GitHub: https://github.com/Yemmmyc

🏁 Conclusion
This project demonstrates the Blue/Green deployment strategy in a simple but realistic DevOps workflow, complete with:

Dockerized applications

Nginx reverse proxy routing

Automated environment switching

Zero downtime and rollback support

Perfect foundation for integrating CI/CD automation in future stages.
