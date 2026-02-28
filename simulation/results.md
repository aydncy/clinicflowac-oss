# Simulation Results (v0.1)

Based on `simulation/assumptions.md`, we compare a baseline "message chaos" operational model
vs ClinicFlowAC’s event-based workflow execution model.

Sample size: 1000 simulated appointments over 90 days.

---

## Summary Table

| Metric | Baseline (Message Chaos) | ClinicFlowAC (Event-Based) | Change |
|---|---:|---:|---:|
| Missed appointment rate | 18% | 12% | **-33%** relative reduction |
| Document completion (before visit) | 55% | 85% | **+55%** relative increase |
| Consent recorded (structured) | 60% | 98% | **+63%** relative increase |
| Avg workflow completion time | 48h | 30h | **-38%** relative reduction |
| Audit exportability | 0% | 100% | **+100pp** (proof packs available) |

---

## Interpretation (v0.1)

- Fewer missed appointments through structured reminders and state tracking  
- Higher document completeness by enforcing checklists as workflow gates  
- Near-complete consent coverage via structured consent events  
- Faster completion via deterministic workflow routing  
- Auditability enabled by default via proof pack export

---

## Disclaimer

These are simulation estimates only.
Real-world pilot data will replace these values.
