# Simulation Assumptions (v0.1)

This document defines the numerical assumptions used in the simulation model.

No real patient data is used.

---

## Sample Size

- 1000 simulated appointments
- 90-day operational window
- Small clinic model (1–3 practitioners)

---

## Baseline Model (Message Chaos)

Assumptions based on industry observations:

- Missed appointment rate: 18%
- Document completion rate before visit: 55%
- Consent recorded in structured form: 60%
- Average workflow completion time: 48 hours
- Audit exportability: 0%

Characteristics:
- Manual tracking
- Ad-hoc follow-ups
- Inconsistent document enforcement
- No append-only event log

---

## ClinicFlowAC Model (Event-Based Workflow)

Assumptions under structured workflow execution:

- Missed appointment rate: 12%
- Document completion rate before visit: 85%
- Consent recorded in structured form: 98%
- Average workflow completion time: 30 hours
- Audit exportability: 100%

Characteristics:
- Event-driven state tracking
- Checklist enforcement
- Consent as structured event
- Proof pack export available

---

## Methodology

The simulation compares percentage deltas between:

Baseline vs Event-Based Model

Improvement calculated as relative reduction or increase.

---

## Note

These values are conservative simulation estimates.
Real-world pilot data will replace simulation assumptions.
