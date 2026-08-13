# Codex Production Review Prompt

```text
Use Vibe Ready as the production-readiness standard.

Review this project as an AI-built/vibe-coded app that may be headed toward launch.

Start with `checklists/quick-start.md`. Ask which plain-language sharing level matches the app. If the builder does not know, continue with Private Beta ("sharing with a few trusted people") as an explicit temporary assumption. Do not make the builder answer every advanced checklist item.

Read:
- README and setup docs
- package manifests
- dependency lockfiles and package manager config
- env examples
- deployment config
- auth and API routes
- API inventory, request validation, gateways/BFFs, outbound URL fetches, and protocol choices
- session expiry, revocation, account recovery, and device/session management
- API response schemas, public versioning commitments, and async event delivery
- JWT/session/token verification and service-to-service auth
- database schema/migrations
- object storage, upload, CDN, and cache code
- payment code if present
- transactional messaging and deliverability configuration if present
- account deletion, export, retention, privacy-request, and processor cleanup flows
- support escalation, customer-impact telemetry, and security/trust claims
- AI/model/agent/tool code if present
- RAG ingestion, source permissions, vector/search indexes, retrieval provenance, freshness, and deletion paths if present
- logging, monitoring, alerting, and cloud cost configuration
- tests

Run `scripts/prodcheck.sh --stage <selected-stage> .` from the Vibe Ready repo, or run the equivalent path to that script from the target project, if shell access is available. Treat GOOD results as evidence to inspect, not proof. Do not use `--strict` unless CI enforcement was requested.

Return findings by severity:
- Blocker
- High
- Medium
- Low

For each finding include:
- area
- evidence from file/path or observed behavior
- concrete fix

Do not give generic advice. Do not invent evidence. Treat missing evidence as a risk.
Do not recommend a cache, queue, search engine, gateway, microservice, container platform, or additional database without workload evidence. Consider the current simpler design and record material trade-offs in an architecture decision.

Pay special attention to:
- dependency supply-chain risk and unpinned installs
- auth provider fit, self-hosted auth ownership, and enterprise SSO/SAML needs
- JWT algorithm/issuer/audience validation
- CORS, CSP, cookie flags, and browser security headers
- database blob storage versus object storage for user files
- structural versus semantic API validation, payload limits, SSRF, legacy/shadow endpoints, and gateway-bypass authorization
- measured latency/capacity budgets, event ordering scope, and rollout traffic/health gates
- RAG tenant isolation, source provenance, retrieval quality, index lifecycle, and prompt injection from retrieved documents
- cache invalidation, cache stampedes, and stale authorization/entitlement data
- monitoring, structured logs, CI/CD friction, rollback, and cloud cost alerts
- critical-email delivery, payment recovery/disputes, and human escalation for contested AI/support outcomes
- data-lifecycle coverage across databases, uploads, caches, indexes, backups, analytics, and subprocessors
```
