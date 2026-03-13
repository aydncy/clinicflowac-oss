# ClinicFlowAC — Workflow Event Specification (WES) v0.1

This document defines the minimal, interoperable event format for ClinicFlowAC workflow history.

## Goals
- A small, clear event vocabulary for clinic operations
- Append-only, audit-friendly event streams
- Interoperable exports ("proof packs") independent of UI and channel

## Non-goals
- Clinical record storage (EHR replacement)
- Storing sensitive health data in public repos

---

## Event Envelope (required)

All events MUST include:

- `id` (string): unique event id
- `type` (string): event type
- `ts` (string): ISO8601 timestamp
- `actor` (string): `system` | `patient` | `clinic` | `integration`
- `entity` (object): primary entity reference
  - `kind` (string): `appointment` | `document` | `consent`
  - `id` (string)
- `data` (object): event payload (type-specific)

### Example Envelope

```json
{
  "id": "evt_001",
  "type": "appointment_created",
  "ts": "2026-02-28T09:00:00Z",
  "actor": "system",
  "entity": { "kind": "appointment", "id": "apt_demo_001" },
  "data": { "scheduled_for": "2026-03-01T10:30:00Z" }
}
