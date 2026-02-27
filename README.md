# ClinicFlowAC (OSS)
Open-source Flutter starter for clinic workflows (WhatsApp/email/SMS)

**WhatsApp / Email / SMS → Appointment + Documents + Consent + Audit Trail**

ClinicFlowAC is an open-source Flutter starter and reference architecture for building clinic workflow agents.
It turns unstructured patient messages into verified, auditable operational workflows—without requiring a complex EHR rollout.

Founder: Aydın Ceylan (Antalya, TR)  
LinkedIn: https://www.linkedin.com/in/aydinceylan07/  
GitHub: https://github.com/aydncy

## Quickstart

This repository is a Flutter starter/reference architecture for clinic workflows.
It is not a medical product and ships with demo data only.

### Prerequisites
- Flutter SDK (stable)
- A device/emulator (Android recommended)
- Git

### Run (demo mode)
1. Clone the repo:
   - `git clone https://github.com/aydncy/clinicflowac-oss.git`
   - `cd clinicflowac-oss`
2. Install dependencies:
   - `flutter pub get`
3. Run on a device/emulator:
   - `flutter run`

### Demo scenario (what to try)
- Create an appointment (patient + date/time).
- Attach a document (demo/placeholder).
- Record/update consent status.
- Export a “proof pack” (JSON + human-readable summary) and inspect what is included.

### Repository structure (high level)
- `lib/` app code
- `test/` tests (if present)
- `docs/` additional documentation (if present)

## Why this matters (the global gap)
Small clinics run on WhatsApp and email. The result is operational chaos:
missed appointments, missing documents, unclear responsibility, and no audit trail.
ClinicFlowAC focuses on execution + proof, not chat.

## What ClinicFlowAC does
- Captures appointment intent (book / reschedule / cancel) and routes it to the right workflow
- Collects required documents through secure links (not inside Issues)
- Records consent events and generates an audit log (“proof pack”)
- Supports channel failover: WhatsApp → email → SMS (configurable)

## Who it’s for
- Independent clinics, dental clinics, aesthetic clinics, polyclinics
- Builders and teams who want a production-grade starting point for “agentic workflows” in healthcare operations

## Roadmap (90 days) — measurable outputs
Phase 1 (0–30 days)
- Flutter starter + self-serve onboarding (first clinic in 10 minutes)
- Appointment workflow + reminder scheduler
- Minimal dashboard (today / tomorrow / overdue)

Phase 2 (31–60 days)
- Document upload portal + checklist per appointment type
- Consent capture + immutable event log
- Exportable audit report (PDF/JSON)

Phase 3 (61–90 days)
- WhatsApp Cloud API integration (templates + webhooks)
- Email integration (Microsoft Graph) + SMS via CPaaS
- 5 pilot clinics, first paid plan

## Funding & support (non-dilutive)
We are seeking non-dilutive funding and sponsorship to accelerate a 90‑day build sprint:
- MVP delivery + documentation + security hardening
- Pilot onboarding and measurable outcomes

## Contributing
Issues and PRs are welcome. Please include:
- Expected behavior
- Steps to reproduce
- Screenshots/logs (avoid sensitive data)

## Security
Do not submit personal or sensitive health data in issues.
Please report vulnerabilities privately (see SECURITY.md).

## Sponsoring
If this project helps you, consider sponsoring the 90-day build sprint:
https://github.com/sponsors/aydncy

## License
MIT
