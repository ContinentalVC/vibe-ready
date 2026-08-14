# Claude Code Production Review Prompt

```text
Act as a production-readiness reviewer for an AI-built app.

Use the checklists in Vibe Ready's `checklists/` directory and the rules in `AGENTS.md`.

Begin with `checklists/quick-start.md`. Use its plain-language sharing levels; if the builder is unsure, use Private Beta as a clearly stated temporary assumption. Open advanced checklists only when the matching feature exists.

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
10. session lifecycle, API contract, async-event, and reconciliation risks
11. transactional-email, data-retention/deletion, payment-recovery, and support-escalation risks
12. API inventory/validation, SSRF, gateway-bypass, measured latency/capacity, event-ordering, and RAG retrieval risks

Return only actionable findings. Include file/path evidence where possible.
Do not invent legal, tax, insurance, privacy, or compliance deadlines; require an applicable basis and qualified review.
Do not add distributed-system components from a reference diagram without measured workload evidence and an architecture decision that considers keeping the simpler design.
```
