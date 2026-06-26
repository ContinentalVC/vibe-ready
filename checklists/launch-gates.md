# Launch Gates

Use the lowest gate that matches the actual exposure of the app.

## Prototype

Allowed:

- Local demos
- Fake data
- No real users
- No sensitive data
- No production payments

Required:

- Clear warning that it is not production-ready
- No real credentials in code

## Private Beta

Allowed:

- Trusted users
- Limited traffic
- Known support path

Required:

- Auth for private data
- Basic authorization checks
- Staging or preview deploy
- Backups for user-created data
- Structured error logging
- Rollback plan
- Rate limits on expensive endpoints
- Expected beta traffic and support capacity are defined
- Dependency lockfiles are committed where applicable
- Object storage permissions are reviewed for user-uploaded files

## Public Beta

Allowed:

- Public signups
- Limited production usage

Required:

- Monitoring and alerts
- Safe user-facing errors
- Secret scanning
- Dependency scanning
- A basic dynamic security scan or equivalent manual web security pass has been run against the deployed app
- Tested unhappy paths
- Feature flags or kill switches for risky features
- AI cost controls if AI is exposed
- Payment checklist if payments are live
- Risky changes use staged or canary rollout where practical
- Cache invalidation and stale-data behavior are reviewed for user-visible, billing, auth, and entitlement data

## Production

Required:

- All launch blockers resolved or explicitly accepted by owner
- Rollback tested
- Backups and restore tested
- Incident response owner defined
- Auth, authorization, secrets, database, logging, and monitoring reviewed
- Supply chain, file storage, caching, browser security headers, and service-to-service auth reviewed where applicable
- Critical workflows tested with real-world edge cases
- SLO or reliability target defined for critical workflows
- Alerting fires when reliability is degrading or error budget is burning
- Expected load and spike behavior tested or explicitly accepted as a risk
- Cloud cost attribution and budget alerts exist for the expected launch footprint
- Post-launch monitoring plan

## Enterprise-Ready

Required:

- Tenant isolation model documented
- Audit logs for sensitive actions
- Role-based access control
- Enterprise auth requirements such as SSO, SAML/OIDC, SCIM, domain capture, and session policies are implemented or explicitly out of scope
- Data deletion process
- Privacy policy and terms
- Incident response process
- Evidence for backups, restores, monitoring, access control, security practices, and vulnerability management
- Support and escalation path
