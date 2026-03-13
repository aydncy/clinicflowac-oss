# Simulation Pilot — Impact Report v0.1

This simulation evaluates ClinicFlowAC's event-based workflow execution model
against a baseline "message chaos" operational model.

No real patient data is used.

---

## Purpose
- Produce measurable, reproducible impact evidence without requiring live pilots
- Provide grant-ready proof for operational value

---

## Scenarios
We simulate appointment workflows for small clinics:
- booking
- reschedule
- cancellation
- document requests and completion
- consent recording

---

## Metrics (from IMPACT.md)
- Missed appointment rate
- Document completion rate
- Consent recording coverage
- Workflow completion time
- Audit readiness score

---

## Baseline Model (Message Chaos)
Assumptions:
- Requests arrive via WhatsApp/email/SMS without structured state
- Manual follow-ups are inconsistent
- Document collection is ad-hoc
- Consent is inconsistently recorded

Outputs:
- Higher missed appointments
- Lower document completeness
- Lower consent coverage
- No exportable audit trail

---

## ClinicFlowAC Model (Event-based Execution)
Assumptions:
- Every state change emits an append-only workflow event
- Document checklist enforced per appointment type
- Consent recorded as structured event
- Proof pack export available for each appointment

Outputs:
- Lower missed appointments
- Higher document completeness
- High consent coverage
- 100% audit exportability

---

## Deliverables of This Simulation
- A synthetic dataset (no PHI)
- A reproducible methodology
- A before/after metric comparison table
- A short impact narrative summary

---

## Next
- Add dataset generator (`simulation/sim_dataset.csv`)
- Add results table (`simulation/results.md`)
- Add assumptions & parameters (`simulation/assumptions.md`)
