# Event model (append-only log)

Goal: represent all important clinic workflow changes as append-only events.
No silent in-place edits; history is a list of events.

## Core concepts

- **Aggregate**: thing we track over time (appointment, patient, document, consent).
- **Event**: immutable record of “something that happened” at a point in time.
- **Proof pack**: exportable bundle derived from events (JSON + human-readable).

## Event shape (draft)

Each event has at least:

- `id`: string (UUID)
- `aggregateType`: `"appointment" | "patient" | "document" | "consent"`
- `aggregateId`: string (UUID or local ID)
- `type`: string (see event types below)
- `timestamp`: ISO 8601 string
- `actor`: string (staff ID, system, etc.)
- `payload`: JSON object (event-specific fields)

## Event types (first pass)

### Appointment

- `APPOINTMENT_CREATED`
- `APPOINTMENT_RESCHEDULED`
- `APPOINTMENT_CANCELLED`
- `REMINDER_SCHEDULED`
- `REMINDER_SENT`

### Documents

- `DOCUMENT_REQUESTED`
- `DOCUMENT_UPLOADED`
- `DOCUMENT_REJECTED` (wrong / incomplete)
- `DOCUMENT_APPROVED`

### Consent

- `CONSENT_GIVEN`
- `CONSENT_REVOKED`
- `CONSENT_EXPIRED`

### Messaging / channels

- `MESSAGE_RECEIVED` (WhatsApp/email/SMS)
- `MESSAGE_SENT`
- `CHANNEL_FALLBACK` (WhatsApp → email, etc.)

## Storage (MVP idea)

- In Flutter, keep events as a local list (e.g. in a lightweight database or file).
- Never overwrite old events; always append a new one.
- Views (screens) compute current state by folding over events.

Future:
- Mirror events to a backend (event store) for multi-device and long-term storage.

## DEMO_SCENARIO mapping

For the demo scenario in `DEMO_SCENARIO.md`, expected event sequence:

1. `APPOINTMENT_CREATED`
2. `DOCUMENT_REQUESTED`
3. `DOCUMENT_UPLOADED`
4. `CONSENT_GIVEN`
5. `CONSENT_REVOKED` (or updated)
6. `PROOF_PACK_EXPORTED` (event to be added)

## Next steps

- Refine event types and payloads per aggregate.
- Add Dart models for `Event` and helpers to project events into current state.
- Implement a simple in-memory + local persistence layer.
- Update DEMO_SCENARIO.md with the actual event sequence once implemented.
