# Production Readiness Checklist

Reference anchor: aligned with practical launch-readiness guidance from OWASP Top 10 2021, OWASP ASVS-style controls, 12-Factor config discipline, cloud well-architected security/reliability guidance, and Google SRE production-readiness practices.

Use this before calling an app production-ready.

## Launch Blockers

- [ ] Secure authentication exists for protected areas.
- [ ] Authorization is enforced server-side.
- [ ] Secrets are stored server-side or in a secrets manager.
- [ ] No production secrets are committed.
- [ ] Database schema changes use migrations.
- [ ] Production, staging, and development data are separated.
- [ ] Backups exist and restore has been tested.
- [ ] Rollback steps are documented and tested.
- [ ] User-facing errors do not expose stack traces or secrets.
- [ ] Basic monitoring exists for uptime, errors, and latency.
- [ ] Critical third-party failures have defined fallback behavior.

## Deployment

- [ ] Deploys are not made directly from local machines to production.
- [ ] Preview or staging deploys exist.
- [ ] Risky features can be disabled or rolled back.
- [ ] Risky releases roll out in stages such as internal, beta, canary, percentage rollout, then full rollout.
- [ ] Operators can roll back first and diagnose after when user impact is active.
- [ ] Recovery and rollback have been exercised, not just documented.
- [ ] Environment variables are documented.
- [ ] CI runs tests, lint, dependency audit, and secret scanning.
- [ ] Post-deploy monitoring is part of the release process.

## Backend And API

- [ ] Business logic lives server-side.
- [ ] Input validation exists at API boundaries.
- [ ] Rate limits exist for public or expensive endpoints.
- [ ] Slow tasks use background jobs where needed.
- [ ] External API calls are wrapped in service modules.
- [ ] API errors return safe, predictable responses.

## Database

- [ ] Migrations are version-controlled.
- [ ] Production migrations are backward-compatible where possible.
- [ ] Destructive schema changes use an expand-contract plan and are not bundled with dependent application changes in the same deploy.
- [ ] Rollback or forward-fix behavior is defined for failed migrations.
- [ ] Indexes exist for common queries.
- [ ] Slow queries can be inspected.
- [ ] Connection pooling is configured where needed.
- [ ] Duplicate or inconsistent records are handled.

## Data Protection

- [ ] TLS/HTTPS is enforced for all production traffic.
- [ ] HTTP redirects to HTTPS.
- [ ] Sensitive data is encrypted at rest in databases, backups, and object storage where applicable.
- [ ] Sensitive logs, exports, and attachments have retention and access controls.

## Observability

- [ ] Structured logs include timestamp, request ID, and relevant entity IDs.
- [ ] Logs avoid secrets and sensitive payloads.
- [ ] Errors are searchable.
- [ ] Alerts exist for downtime and elevated error rates.
- [ ] Alerts are actionable and route to a page, ticket, or log-only destination intentionally.
- [ ] An SLO or user-facing reliability target is defined for critical workflows.
- [ ] Error-budget burn or equivalent reliability drift is visible before users report it.
- [ ] Queue depth, database performance, and background failures are visible where applicable.

## Capacity And Resilience

- [ ] Expected launch traffic and credible spike traffic are estimated.
- [ ] Load testing or realistic stress testing has identified the first bottleneck.
- [ ] Resource limits, autoscaling, queue limits, or backpressure behavior are defined where applicable.
- [ ] Failure drills or recovery exercises prove the system can recover from common dependency, deploy, or infrastructure failures.

## Frontend

- [ ] Loading, empty, error, and success states exist.
- [ ] Forms handle invalid, empty, duplicate, and large inputs.
- [ ] Double-clicks and rapid submissions do not duplicate critical actions.
- [ ] App has been checked on mobile and desktop.
- [ ] Product can be understood without a live demo.
