# Codex Production Review Prompt

```text
Use Vibe Ready as the production-readiness standard.

Review this project as an AI-built/vibe-coded app that may be headed toward launch.

Read:
- README and setup docs
- package manifests
- dependency lockfiles and package manager config
- env examples
- deployment config
- auth and API routes
- JWT/session/token verification and service-to-service auth
- database schema/migrations
- object storage, upload, CDN, and cache code
- payment code if present
- AI/model/agent/tool code if present
- logging, monitoring, alerting, and cloud cost configuration
- tests

Run `scripts/prodcheck.sh .` from the Vibe Ready repo, or run the equivalent path to that script from the target project, if shell access is available.

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

Pay special attention to:
- dependency supply-chain risk and unpinned installs
- auth provider fit, self-hosted auth ownership, and enterprise SSO/SAML needs
- JWT algorithm/issuer/audience validation
- CORS, CSP, cookie flags, and browser security headers
- database blob storage versus object storage for user files
- cache invalidation, cache stampedes, and stale authorization/entitlement data
- monitoring, structured logs, CI/CD friction, rollback, and cloud cost alerts
```
