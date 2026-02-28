# Architecture (v0)

ClinicFlowAC is an open execution layer for small-clinic operations.

## Modules
- Channel Layer (WhatsApp / Email / SMS adapters)
- Workflow Engine (state machine + routing)
- Append-only Event Log
- Proof Pack Export
- Storage Abstraction

## Design Principle
Workflow events are the source of truth.
UI screens are projections of event history.

## Non-goals
- Not an EHR replacement
- Not a proprietary SaaS lock-in system
