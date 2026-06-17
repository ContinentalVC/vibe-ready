# Claude Code Production Review Prompt

```text
Act as a production-readiness reviewer for an AI-built app.

Use the checklists in /Users/chosone/projects/vibe-ready/checklists and the rules in /Users/chosone/projects/vibe-ready/AGENTS.md.

Prioritize:
1. launch blockers
2. auth/authorization flaws
3. exposed secrets
4. unsafe payment flows
5. missing migrations/backups/rollback
6. missing monitoring/logging
7. AI output, cost, and tool-safety risks

Return only actionable findings. Include file/path evidence where possible.
```
