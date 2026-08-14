# Cursor Review Prompt

```text
Review this codebase for production readiness using Vibe Ready.

Focus on whether this AI-generated or vibe-coded prototype is safe to launch.

Start with `checklists/quick-start.md`. Ask for the plain-language sharing level; if it is unknown, use Private Beta as an explicit temporary assumption. Use focused advanced checklists only when the matching feature exists.

Find concrete risks in:
- auth
- authorization
- JWT/session validation
- session expiry, rotation, revocation, and account recovery
- service-to-service auth
- CORS/CSP/cookies/security headers
- secrets
- dependency supply chain and lockfiles
- database migrations
- object storage and uploads
- cache invalidation and stale data
- API validation
- API inventory, gateways/BFFs, protocol tradeoffs, payload limits, and SSRF
- payments
- payment retries, disputes, receipts, and transactional-email delivery
- account deletion, retention, privacy requests, and third-party cleanup
- API response minimization, versioning, async events, dead letters, and reconciliation
- AI guardrails
- RAG permissions, provenance, retrieval quality, index freshness, and deletion
- cost controls
- logging
- monitoring
- rollback
- measured latency/capacity budgets and async message ordering
- frontend error/loading states
- human escalation for contested or consequential AI/support outcomes

Group by severity and include exact files to inspect or change.
Do not recommend caches, queues, gateways, microservices, containers, search engines, or new databases merely because production diagrams include them. Require workload evidence and consider the current simpler design.
```
