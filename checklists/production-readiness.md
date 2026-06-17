# Production Readiness Checklist

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
- [ ] Indexes exist for common queries.
- [ ] Slow queries can be inspected.
- [ ] Connection pooling is configured where needed.
- [ ] Duplicate or inconsistent records are handled.

## Observability

- [ ] Structured logs include timestamp, request ID, and relevant entity IDs.
- [ ] Logs avoid secrets and sensitive payloads.
- [ ] Errors are searchable.
- [ ] Alerts exist for downtime and elevated error rates.
- [ ] Queue depth, database performance, and background failures are visible where applicable.

## Frontend

- [ ] Loading, empty, error, and success states exist.
- [ ] Forms handle invalid, empty, duplicate, and large inputs.
- [ ] Double-clicks and rapid submissions do not duplicate critical actions.
- [ ] App has been checked on mobile and desktop.
- [ ] Product can be understood without a live demo.
