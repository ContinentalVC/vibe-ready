# Launch Gates

Use the lowest gate that matches the actual exposure of the app.

## Maturity Matrix

Not everything is required from day 1. Use this matrix to determine which checklist domains are required at each stage. Items appear at the stage where they first become required and cascade to all higher stages.

| Domain | Prototype | Private Beta | Public Beta | Production | Enterprise |
|--------|:----------:|:------------:|:-----------:|:----------:|:----------:|
| Auth (login, sessions) | | ✅ | ✅ | ✅ | ✅ |
| Authorization (permissions, ownership) | | ✅ | ✅ | ✅ | ✅ |
| Secrets management (no committed keys) | ✅ | ✅ | ✅ | ✅ | ✅ |
| AI-tool artifacts kept out of version control | ✅ | ✅ | ✅ | ✅ | ✅ |
| Database migrations | | ✅ | ✅ | ✅ | ✅ |
| Backups & rollback plan | | ✅ | ✅ | ✅ | ✅ |
| Safe user-facing errors | | ✅ | ✅ | ✅ | ✅ |
| Rate limiting (expensive endpoints) | | ✅ | ✅ | ✅ | ✅ |
| Dependency lockfiles | | ✅ | ✅ | ✅ | ✅ |
| Branch protection & merge gates | | ✅ | ✅ | ✅ | ✅ |
| Session lifecycle (regeneration, timeout, redirects) | | ✅ | ✅ | ✅ | ✅ |
| Monitoring & alerting | | | ✅ | ✅ | ✅ |
| Secret / dependency scanning | | | ✅ | ✅ | ✅ |
| Security scan (DAST or manual) | | | ✅ | ✅ | ✅ |
| Browser security headers (CSP, framing) | | | ✅ | ✅ | ✅ |
| Third-party script inventory | | | ✅ | ✅ | ✅ |
| Accessibility (WCAG AA) | | | ✅ | ✅ | ✅ |
| Edge / DDoS protection | | | ✅ | ✅ | ✅ |
| MFA for admin & privileged accounts | | | ✅ | ✅ | ✅ |
| Privacy policy & terms (before public signup) | | | ✅ | ✅ | ✅ |
| API versioning & deprecation policy | | | ✅ if API | ✅ | ✅ |
| Cache invalidation (auth, billing, entitlements) | | | ✅ | ✅ | ✅ |
| AI output validation & safety | | | ✅ if AI | ✅ | ✅ |
| AI cost controls | | | ✅ if AI | ✅ | ✅ |
| AI data scoping & retrieval permissions | | | ✅ if AI | ✅ | ✅ |
| Agent identity & egress control | | | ✅ if agents | ✅ | ✅ |
| AI disclosure & consent (where regulated) | | | ✅ if AI | ✅ | ✅ |
| Payment idempotency & webhook verification | | | ✅ if pay | ✅ | ✅ |
| Feature flags / kill switches | | | ✅ | ✅ | ✅ |
| DevSecOps in CI | | | ✅ | ✅ | ✅ |
| Load / stress testing | | | | ✅ | ✅ |
| DR strategy (RTO / RPO) | | | | ✅ | ✅ |
| SLO / error budgets | | | | ✅ | ✅ |
| Cloud cost attribution & alerts | | | | ✅ | ✅ |
| Incident response process | | | | ✅ | ✅ |
| Status page & incident communication | | | | ✅ | ✅ |
| Postmortem process | | | | ✅ | ✅ |
| Backup granularity meets stated RPO | | | | ✅ | ✅ |
| Service network segmentation & least privilege | | | | ✅ | ✅ |
| Tenant isolation | | | | | ✅ |
| Shared-layer tenant scoping (cache, search, queues, storage) | | | | | ✅ |
| Audit logs (sensitive actions) | | | | | ✅ |
| Enterprise auth (SSO / SAML / SCIM) | | | | | ✅ |
| Data deletion / export process | | | | | ✅ |
| Regulated-data agreements (where applicable) | | | | | ✅ |

**How to use:** Determine the project's current stage. Apply only the checked items for that stage and below. Flag unchecked items at higher stages as recommendations with a timeline, not as blockers.

## Gates in Detail

Allowed:

- Local demos
- Fake data
- No real users
- No sensitive data
- No production payments

Required:

- Clear warning that it is not production-ready
- No real credentials in code
- Screenshots, recordings, and logs produced by AI coding tools are not committed, and no repository is public unless that is intended

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
- Branch protection prevents direct pushes to the default branch, and merges require review
- Session handling covers regeneration on login, idle and absolute timeout, and validated redirect targets

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
- Core production components are in place: CI/CD pipeline, DNS, load balancer, CDN (if static assets), API gateway, backend services, database, cache, full-text search (if needed), job queue (if async tasks), log aggregation, metrics, and alerting
- API testing covers at minimum smoke, functional, and security test types
- DevSecOps practices are integrated: automated security checks in CI, container scanning, secret management, and vulnerability management
- Browser security headers are set, including framing protection and a Content Security Policy rolled out in report-only mode first
- Every externally loaded script, font, pixel, and iframe is inventoried, and third-party scripts are kept off login, checkout, and admin pages
- Keyboard operability, screen-reader labeling, and WCAG AA contrast are verified
- Rate limiting and bot protection exist at the edge, ahead of application compute
- Public APIs are versioned and have a documented deprecation path
- AI features scope data access to the authenticated user outside the prompt, and agent tools enforce outbound allowlists
- AI disclosure, consent, and generation logging are in place where regulation requires them
- Multi-factor authentication is available to users and required for admin and support accounts
- A privacy policy and terms of service are published and reflect the app's actual data flows, with a data processing agreement where third parties process user data

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
- Backup frequency actually meets the stated RPO, and a timed restore drill confirms the RTO
- Services are network-segmented and authenticate each other, credentials follow least privilege, and storage separates public assets from private data
- A status page hosted off the application's own infrastructure exists, with a defined incident update cadence and owner
- A postmortem template exists and reviews are blameless, time-bounded, and searchable
- Support tickets are reviewed as a monitoring signal and categorized by root cause
- System design pillars are documented: scalability approach, availability target (e.g., "4 nines"), reliability expectations, and performance budgets under peak load

## Enterprise-Ready

Required:

- Tenant isolation model documented
- Tenant scoping verified in shared layers beyond the database: cache keys, search indexes, job queues, object storage paths, log streams, and vector stores
- Audit logs for sensitive actions
- Role-based access control
- Enterprise auth requirements such as SSO, SAML/OIDC, SCIM, domain capture, and session policies are implemented or explicitly out of scope
- Data deletion process, with cascading relationships mapped and a defined retention window
- Privacy policy and terms
- Service agreement with stated uptime and response commitments, and liability coverage matching the contracts being signed
- Regulated-data scope determined explicitly, with required vendor agreements signed where it applies
- Incident response process
- Evidence for backups, restores, monitoring, access control, security practices, and vulnerability management
- Support and escalation path
