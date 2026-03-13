# ClinicFlowAC API Specification

## Overview
Event-driven architecture for clinic workflow operations.

## Create Appointment

POST /api/v1/appointments

```json
{
  "patient_id": "pat_001",
  "scheduled_for": "2026-03-01T10:00:00Z",
  "appointment_type": "consultation"
}
