# Threat Model (v0)

ClinicFlowAC is designed to minimize sensitive data exposure while preserving auditability.

## Security Goals
- Minimize PII/PHI exposure
- Provide tamper-evident operational history (auditability)
- Keep contributor workflows safe (no sensitive data in issues/logs)

## Primary Assets
- Workflow event log (audit evidence)
- Document links and metadata
- Consent records (operational events)
- Configuration/secrets (future integrations)

## Key Threats
1. **Accidental leakage** of sensitive data via GitHub issues, logs, screenshots
2. **Unauthorized access** to document links or uploads
3. **Event log tampering** (modification/removal)
4. **Credential exposure** (API keys for WhatsApp/Email/SMS)
5. **Replay / spoofing** of inbound messages (future channel integrations)

## Mitigations (v0)
- Strict policy: no PHI in GitHub issues; guidance in SECURITY.md
- Demo mode uses placeholders; no real patient data required
- Document handling should use expiring links and access controls (future backend)
- Event log will become tamper-evident via hash chaining and signatures (v0.2 target)
- Secrets stored only in secure env/config (never committed)

## Next Milestones
- Add integrity layer to proof packs (hash chain, signature support)
- Self-hostable backend reference with auth + access control
- Security review checklist for integrations
