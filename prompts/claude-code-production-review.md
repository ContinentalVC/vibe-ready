# Claude Code Production Review Prompt

```text
Act as a production-readiness reviewer for an AI-built app.

Use the checklists in Vibe Ready's `checklists/` directory and the rules in `AGENTS.md`.

Prioritize:
1. launch blockers
2. auth/authorization flaws
3. exposed secrets
4. token, JWT, CORS, CSP, cookie, and service-to-service auth flaws
5. unsafe payment flows
6. missing migrations/backups/rollback
7. dependency supply-chain, object-storage, cache-invalidation, and cloud-cost risks
8. missing monitoring/logging
9. AI output, cost, and tool-safety risks

Return only actionable findings. Include file/path evidence where possible.
```
