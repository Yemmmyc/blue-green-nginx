# 🌀 DevOps Intern Stage 2 – Blue/Green Deployment with Nginx Upstreams (Auto-Failover + Manual Toggle)

![Blue/Green Flowchart](A_flowchart_in_the_image_illustrates_a_blue-green_.png)

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

```
blue-green-nginx/
│
├── blue/
│   └── Dockerfile
│   └── server.js
│
├── green/
│   └── Dockerfile
│   └── server.js
│
├── nginx/
│   └── nginx.conf.template
│
├── .env
├── .env.example
├── docker-compose.yml
├── switch.sh
├── rollback.sh
├── switch.ps1
├── rollback.ps1
└── README.md
```

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
```

---

## ⚡ Environment Variables (.env)

```bash
ACTIVE_POOL=blue
BLUE_IMAGE=blue-app:latest
GREEN_IMAGE=green-app:latest
RELEASE_ID_BLUE=1
RELEASE_ID_GREEN=1
```

---

## 🚀 Build and Run the Containers

```bash
# Build app images
docker build -t blue-app:latest ./blue
docker build -t green-app:latest ./green

# Start containers
docker compose up -d
```

---

## 🧪 Testing the Deployment

### Check which environment is active
```bash
curl http://localhost:8080
```

Expected output:
```
💙 Blue App - Version 1
```

---

## 🔁 Switching Environments

Switch between Blue ↔ Green environments using:

### For Linux/macOS:
```bash
./switch.sh
```

### For Windows PowerShell:
```powershell
.\switch.ps1
```

Then verify:
```bash
curl http://localhost:8080
```
Expected output:
```
💚 Green App - Version 1
```

---

## 🧯 Rollback
If you need to revert to the previous environment:

### Linux/macOS:
```bash
./rollback.sh
```

### PowerShell:
```powershell
.
ollback.ps1
```

---

## 📈 Flow Summary

1. **Blue is active** – users see Blue App responses.  
2. **Deploy new release** to Green.  
3. **Switch traffic** using `switch.sh` / `switch.ps1`.  
4. **Validate** Green is working correctly.  
5. **Rollback** if needed using rollback scripts.

---

## 👩‍💻 Author
**Yemisi Okunrounmu**  
*DevOps Intern*  
📧 Email: [your.email@example.com]  
🌐 GitHub: [your GitHub link]

---

## 🏁 Conclusion
This project demonstrates the **Blue/Green deployment strategy** in a simple but realistic DevOps workflow, complete with:
- Dockerized applications  
- Nginx reverse proxy routing  
- Automated environment switching  
- Zero downtime and rollback support  

Perfect foundation for integrating CI/CD automation in future stages.