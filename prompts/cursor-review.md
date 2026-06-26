# Cursor Review Prompt

```text
Review this codebase for production readiness using Vibe Ready.

Focus on whether this AI-generated or vibe-coded prototype is safe to launch.

Find concrete risks in:
- auth
- authorization
- JWT/session validation
- service-to-service auth
- CORS/CSP/cookies/security headers
- secrets
- dependency supply chain and lockfiles
- database migrations
- object storage and uploads
- cache invalidation and stale data
- API validation
- payments
- AI guardrails
- cost controls
- logging
- monitoring
- rollback
- frontend error/loading states

Group by severity and include exact files to inspect or change.
```
