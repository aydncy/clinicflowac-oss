# CLINICFLOWAC DEPLOYMENT GUIDE

## TABLE OF CONTENTS
1. Prerequisites
2. Local Setup
3. Cloud Deployment (FREE)
4. VPS Deployment ($5/mo)
5. Configuration
6. Testing
7. Troubleshooting

---

## 1. PREREQUISITES

### Required:
- Dart 3.0+
- Git
- Terminal/Command line

### Optional:
- Docker (for containerized deployment)
- PostgreSQL (for production)

---

## 2. LOCAL SETUP

### Step 1: Clone
\`\`\`bash
git clone https://github.com/aydncy/clinicflowac-oss.git
cd clinicflowac-oss
\`\`\`

### Step 2: Install
\`\`\`bash
dart pub get
\`\`\`

### Step 3: Run
\`\`\`bash
dart run bin/server.dart
\`\`\`

Server runs on: http://localhost:8080

---

## 3. CLOUD DEPLOYMENT (FREE)

### Option A: Render.com

1. Go to https://render.com
2. Sign up with GitHub
3. Create new Web Service
4. Select: clinicflowac-oss repo
5. Deploy!

URL: https://clinicflowac.onrender.com

### Option B: Railway.app

1. Go to https://railway.app
2. Sign up with GitHub
3. New Project → GitHub Repo
4. Select: clinicflowac-oss
5. Deploy!

---

## 4. VPS DEPLOYMENT ($5/mo)

### DigitalOcean (Recommended)

1. Create Ubuntu 24.04 Droplet ($5/mo)
2. SSH into server
3. Install Dart:

\`\`\`bash
sudo apt update
sudo apt install dart
\`\`\`

4. Clone repo:

\`\`\`bash
git clone https://github.com/aydncy/clinicflowac-oss.git
cd clinicflowac-oss
\`\`\`

5. Install & run:

\`\`\`bash
dart pub get
dart run bin/server.dart
\`\`\`

6. Use systemd for auto-start (optional)

---

## 5. PRODUCTION CONFIGURATION

### Environment Variables

\`\`\`bash
PORT=8080
ENVIRONMENT=production
DATABASE_URL=postgresql://...
\`\`\`

### Reverse Proxy (Nginx)

\`\`\`nginx
server {
    listen 80;
    server_name clinicflowac.yourdomain.com;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
\`\`\`

### SSL/TLS (Free with Let's Encrypt)

\`\`\`bash
sudo certbot certonly --nginx -d clinicflowac.yourdomain.com
\`\`\`

---

## 6. TESTING DEPLOYMENT

### Health Check

\`\`\`bash
curl https://your-deployed-url/health
\`\`\`

Response:
\`\`\`json
{"status":"healthy","service":"ClinicFlowAC","version":"1.0.0"}
\`\`\`

### API Status

\`\`\`bash
curl https://your-deployed-url/status
\`\`\`

---

## 7. TROUBLESHOOTING

### Port already in use

\`\`\`bash
lsof -i :8080
kill -9 <PID>
\`\`\`

### Dart not found

\`\`\`bash
dart --version
\`\`\` 

If not installed: https://dart.dev/get-dart

### Dependencies error

\`\`\`bash
rm -rf .dart_tool pubspec.lock
dart pub get
\`\`\`

---

## SUPPORT

Issues? 
- GitHub: https://github.com/aydncy/clinicflowac-oss/issues
- Email: aydinceylan07@gmail.com

Happy deploying! 🚀

