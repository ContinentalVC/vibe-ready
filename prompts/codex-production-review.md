# Codex Production Review Prompt

```text
Use /Users/chosone/projects/vibe-ready as the production-readiness standard.

Review this project as an AI-built/vibe-coded app that may be headed toward launch.

Read:
- README and setup docs
- package manifests
- env examples
- deployment config
- auth and API routes
- database schema/migrations
- payment code if present
- AI/model/agent/tool code if present
- tests

Run /Users/chosone/projects/vibe-ready/scripts/prodcheck.sh . if shell access is available.

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
```
