DROP TABLE IF EXISTS audit_logs CASCADE;
DROP TABLE IF EXISTS clinic_users CASCADE;
DROP TABLE IF EXISTS medical_records CASCADE;

CREATE TABLE clinic_users (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), clinic_id UUID NOT NULL REFERENCES clinics(id) ON DELETE CASCADE, email VARCHAR(255) NOT NULL, password_hash VARCHAR(255) NOT NULL, full_name VARCHAR(255), role VARCHAR(50) DEFAULT 'doctor', status VARCHAR(50) DEFAULT 'active', last_login TIMESTAMP, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, UNIQUE(clinic_id, email));

CREATE TABLE medical_records (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), clinic_id UUID NOT NULL REFERENCES clinics(id) ON DELETE CASCADE, patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE, appointment_id UUID REFERENCES appointments(id) ON DELETE SET NULL, doctor_id UUID NOT NULL REFERENCES doctors(id) ON DELETE RESTRICT, record_type VARCHAR(100), title VARCHAR(255), content TEXT NOT NULL, attachments JSONB, visibility VARCHAR(50) DEFAULT 'private', created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, created_by UUID);

CREATE TABLE audit_logs (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), clinic_id UUID NOT NULL REFERENCES clinics(id) ON DELETE CASCADE, user_id UUID REFERENCES clinic_users(id) ON DELETE SET NULL, action VARCHAR(255) NOT NULL, resource_type VARCHAR(100), resource_id UUID, changes JSONB, ip_address VARCHAR(45), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
