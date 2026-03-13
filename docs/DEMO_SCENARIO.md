# Demo scenario

Goal: showcase appointment + document + consent workflow, and how auditability works via an append-only event log and exportable proof pack.

## Steps
1. Start the app in demo mode.
2. Create one patient and one appointment.
3. Add a document reference (placeholder) to the appointment.
4. Set consent status and change it once (to create multiple events).
5. Export the proof pack.

## Expected outputs
- An event history that is append-only (new events instead of rewriting old ones).
- Proof pack export:
  - Machine-readable JSON.
  - Human-readable summary (HTML/PDF), containing no secrets by default.
