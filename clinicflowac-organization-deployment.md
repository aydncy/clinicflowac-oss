# CLINICFLOWAC - ORGANIZATION DEPLOYMENT GUIDE

## OVERVIEW
This guide helps organizations deploy ClinicFlowAC across multiple clinics.

## REQUIREMENTS
- Dart 3.0+
- PostgreSQL 12+
- Reverse proxy (Nginx/Apache)
- Domain name
- SSL certificate

## ARCHITECTURE
```
Organization Account
├── Clinic 1
├── Clinic 2
├── Clinic 3
└── Clinic N
```

## STEP 1: INFRASTRUCTURE SETUP

### Server Requirements
- Ubuntu 20.04+ or equivalent
- 2GB RAM minimum
- 20GB disk space
- Static IP address

### Database Setup
```bash
# Install PostgreSQL
sudo apt update
sudo apt install postgresql postgresql-contrib

# Create database
sudo -u postgres createdb clinicflowac_org

# Create user
sudo -u postgres createuser clinicflowac_user
sudo -u postgres psql -c "ALTER USER clinicflowac_user WITH PASSWORD 'secure_password';"
```

## STEP 2: APPLICATION DEPLOYMENT

### Clone Repository
```bash
git clone https://github.com/aydncy/clinicflowac-oss.git
cd clinicflowac-oss
```

### Environment Configuration
```bash
cat > .env << 'EOF'
PORT=8080
ENVIRONMENT=production
DATABASE_URL=postgresql://clinicflowac_user:secure_password@localhost/clinicflowac_org
ORGANIZATION_ID=org_123
REGION=eu-west-1
EOF
```

### Install & Deploy
```bash
dart pub get
dart compile exe bin/server.dart -o clinicflowac_app

# Run as service
sudo systemctl create clinicflowac
```

## STEP 3: REVERSE PROXY (NGINX)
```nginx
upstream clinicflowac {
    server localhost:8080;
}

server {
    listen 80;
    server_name clinicflow.yourorg.com;
    
    location / {
        proxy_pass http://clinicflowac;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## STEP 4: SSL/TLS SETUP
```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot certonly --nginx -d clinicflow.yourorg.com
```

## STEP 5: CLINIC ONBOARDING

Each clinic gets:
```
clinic_id: clinic_001
region: eu-west-1
tenant: org_123_clinic_001
users: 5-50
features: all
```

## STEP 6: MULTI-CLINIC MANAGEMENT

### Dashboard
```
https://clinicflow.yourorg.com/dashboard
├── Clinic 1 Stats
├── Clinic 2 Stats
└── Clinic N Stats
```

### User Management
```bash
# Add clinic admin
POST /api/v1/users
{
  "email": "admin@clinic1.org",
  "clinic_id": "clinic_001",
  "role": "admin"
}
```

## STEP 7: MONITORING

### Health Check
```bash
curl https://clinicflow.yourorg.com/health
```

### Logs
```bash
sudo journalctl -u clinicflowac -f
```

## INTEGRATION CHECKLIST

- [ ] PostgreSQL configured
- [ ] Application deployed
- [ ] Reverse proxy setup
- [ ] SSL configured
- [ ] DNS pointing to server
- [ ] Backups scheduled
- [ ] Monitoring active
- [ ] Team trained

## SUPPORT

Email: org-support@clinicflowac.com
Response: 24 hours

