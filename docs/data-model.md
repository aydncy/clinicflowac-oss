# Data Model (v0)

## Core Entities

### Patient
- `id` (string)
- `display_name` (string, demo)
- `meta` (object, optional)

### Appointment
- `id` (string)
- `patient_id` (string)
- `scheduled_for` (ISO8601 datetime)
- `type` (string)
- `status` (enum: requested, confirmed, rescheduled, cancelled, completed)

### DocumentRequest
- `id` (string)
- `appointment_id` (string)
- `doc_type` (string)
- `required` (boolean)
- `status` (enum: pending, received, verified)

### DocumentArtifact
- `id` (string)
- `request_id` (string)
- `url` (string, placeholder/demo)
- `checksum` (string, optional)
- `uploaded_at` (ISO8601 datetime, demo)

### ConsentEvent
- `id` (string)
- `appointment_id` (string)
- `consent_type` (string)
- `status` (enum: granted, denied)
- `recorded_at` (ISO8601 datetime)

### WorkflowEvent (Append-only)
- `id` (string)
- `type` (string e.g. appointment_created, document_requested)
- `ts` (ISO8601 datetime)
- `actor` (string, e.g. system/patient/clinic)
- `data` (object, event payload)

## Principle
- Events are the primary source of truth. Entities can be reconstructed from the event log.
- Keep PII/PHI out of public storage; demo placeholders only.
