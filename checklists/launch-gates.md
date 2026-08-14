# Launch Gates

Use the lowest gate that matches the actual exposure of the app.

If these names are unfamiliar, start with [`quick-start.md`](quick-start.md). The matrix below routes a coding agent into deeper review; it is not a 355-question form for the builder.

## Maturity Matrix

Not everything is required from day 1. Use this matrix to determine which checklist domains are required at each stage. Items appear at the stage where they first become required and cascade to all higher stages.

| Domain | Prototype | Private Beta | Public Beta | Production | Enterprise |
|--------|:----------:|:------------:|:-----------:|:----------:|:----------:|
| Auth (login, sessions) | | ✅ | ✅ | ✅ | ✅ |
| Session lifecycle (expiry, revocation, recovery) | | ✅ | ✅ | ✅ | ✅ |
| Authorization (permissions, ownership) | | ✅ | ✅ | ✅ | ✅ |
| Secrets management (no committed keys) | ✅ | ✅ | ✅ | ✅ | ✅ |
| Database migrations | | ✅ | ✅ | ✅ | ✅ |
| Backups & rollback plan | | ✅ | ✅ | ✅ | ✅ |
| Safe user-facing errors | | ✅ | ✅ | ✅ | ✅ |
| Rate limiting (expensive endpoints) | | ✅ | ✅ | ✅ | ✅ |
| Dependency lockfiles | | ✅ | ✅ | ✅ | ✅ |
| Monitoring & alerting | | | ✅ | ✅ | ✅ |
| Transactional-message reliability | | ✅ if used | ✅ if used | ✅ if used | ✅ if used |
| Support ownership & escalation | | ✅ | ✅ | ✅ | ✅ |
| Secret / dependency scanning | | | ✅ | ✅ | ✅ |
| Security scan (DAST or manual) | | | ✅ | ✅ | ✅ |
| Cache invalidation (auth, billing, entitlements) | | | ✅ | ✅ | ✅ |
| AI output validation & safety | | | ✅ if AI | ✅ | ✅ |
| RAG permission, provenance & freshness | | | ✅ if RAG | ✅ if RAG | ✅ if RAG |
| AI cost controls | | | ✅ if AI | ✅ | ✅ |
| Payment idempotency & webhook verification | | | ✅ if pay | ✅ | ✅ |
| Feature flags / kill switches | | | ✅ | ✅ | ✅ |
| DevSecOps in CI | | | ✅ | ✅ | ✅ |
| Load / stress testing | | | | ✅ | ✅ |
| Data lifecycle / privacy requests | | | ✅ if personal data | ✅ | ✅ |
| Async event recovery / reconciliation | | | | ✅ if async | ✅ if async |
| DR strategy (RTO / RPO) | | | | ✅ | ✅ |
| SLO / error budgets | | | | ✅ | ✅ |
| Cloud cost attribution & alerts | | | | ✅ | ✅ |
| Incident response process | | | | ✅ | ✅ |
| Tenant isolation | | | | | ✅ |
| Audit logs (sensitive actions) | | | | | ✅ |
| Enterprise auth (SSO / SAML / SCIM) | | | | | ✅ |
| Tenant-wide deletion / export evidence | | | | | ✅ |

**How to use:** Determine the project's current stage. Apply only the checked items for that stage and below. Flag unchecked items at higher stages as recommendations with a timeline, not as blockers.

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
- Session expiration, revocation, and account-recovery behavior are defined
- Staging or preview deploy
- Backups for user-created data
- Structured error logging
- Rollback plan
- Rate limits on expensive endpoints
- Expected beta traffic and support capacity are defined
- Dependency lockfiles are committed where applicable
- Object storage permissions are reviewed for user-uploaded files
- Critical transactional messages are tested and observable if the beta depends on email
- A named support owner and escalation path exist

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
- RAG access controls, source provenance, retrieval quality, and index freshness/deletion behavior are verified if retrieval is exposed
- Payment checklist if payments are live
- Risky changes use staged or canary rollout where practical
- Cache invalidation and stale-data behavior are reviewed for user-visible, billing, auth, and entitlement data
- The actual runtime components are inventoried and owned. CI/CD, DNS, hosting/runtime, data stores, and observability match the app that exists; load balancers, CDNs, gateways, caches, search, queues, containers, and additional services are required only when the workload or platform needs them
- API testing covers at minimum smoke, functional, and security test types
- DevSecOps practices are integrated: automated security checks in CI, secret management, vulnerability management, and container or infrastructure scanning when those artifacts exist
- Account deletion, export, and retention behavior is defined if personal data is collected
- Critical user journeys are measured at the outcome level, and recurring support issues feed back into engineering or observability

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
- Disaster recovery strategy is defined with concrete RTO and RPO targets and has been tested
- System design pillars are documented from actual user and business needs: scalability approach, availability target, reliability expectations, and performance budgets under peak load. Do not copy an availability percentage or reference architecture without evidence that the product needs and can operate it
- Material architecture choices and rejected simpler options are recorded with `templates/architecture-decision-record.md`
- Critical dependencies have bounded deadlines/retries, failure isolation, degraded behavior, and recovery ownership recorded and tested with `templates/dependency-resilience-plan.md` or equivalent
- Delivery speed and stability are measured for improvement using the team's own definitions; external benchmarks are not treated as universal targets
- Capacity and end-to-end latency budgets are based on measured workload paths, including connection setup, gateway/service fan-out, cache/database access, queues, and external dependencies
- Async event or data-projection failures have retry, dead-letter recovery, replay, and reconciliation where applicable
- Data-retention, deletion, privacy-request, and restoration behavior has been tested for the actual systems and processors in use
- Payment recovery, dispute operations, transactional-message delivery, and customer support are operationally owned where applicable

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
- Per-tenant SSO configuration, provisioning, and deprovisioning are tested where enterprise identity is offered
- Security questionnaire and public trust claims are backed by current evidence
