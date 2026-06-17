# Vibe Ready

Production-readiness toolkit for AI-built and vibe-coded apps.

Vibe Ready helps you take a fast prototype from tools like Claude Code, Codex, Cursor, Lovable, Bolt, v0, Replit, or similar agentic builders and check whether it is actually safe to launch.

This repo is intentionally lightweight:

- Agent-readable instructions
- Production checklists
- Launch gates by risk level
- Review prompts for Claude/Codex/Cursor
- Local shell checks for common footguns
- Templates for rollback, incidents, env vars, and launch plans

It is not a framework, SaaS platform, or compliance certification.

## The Core Idea

AI-generated prototypes are often demo-ready before they are production-ready.

Vibe Ready gives human builders and coding agents a shared definition of "ready":

- Auth works and authorization is enforced.
- Secrets are not exposed.
- Database changes use migrations.
- Backups and rollback are planned.
- Logs and monitoring exist.
- AI outputs are validated.
- Costs and rate limits are controlled.
- Payments, webhooks, and tenant boundaries are reviewed.
- Risky changes have human approval gates.

## Quick Start

Copy or reference this repo from the project you want to review:

```bash
cd /path/to/your/app
/Users/chosone/projects/vibe-ready/scripts/prodcheck.sh .
```

Then ask your agent:

```text
Read /Users/chosone/projects/vibe-ready/AGENTS.md.
Use the checklists in /Users/chosone/projects/vibe-ready/checklists.
Review this app for launch blockers, production risks, and missing safeguards.
Return only actionable findings grouped by severity.
```

## Repo Structure

```text
vibe-ready/
  README.md
  AGENTS.md
  checklists/
    production-readiness.md
    ai-app-readiness.md
    auth-security.md
    payment-readiness.md
    launch-gates.md
    multi-tenant-enterprise.md
  prompts/
    codex-production-review.md
    claude-code-production-review.md
    cursor-review.md
  templates/
    env.example
    launch-plan.md
    rollback-plan.md
    incident-response.md
    risk-register.md
  scripts/
    prodcheck.sh
```

## Suggested Workflow

1. Run `scripts/prodcheck.sh` against the target project.
2. Have Claude/Codex/Cursor perform a checklist-based review.
3. Classify findings as launch blockers, pre-launch fixes, post-launch hardening, or accepted risks.
4. Fill out the launch and rollback templates.
5. Re-run the review before release.

## Launch Gates

Use these default gates:

- **Prototype:** local demo only; no real users or sensitive data.
- **Private beta:** trusted users; logs, backups, auth, and rollback exist.
- **Public beta:** rate limits, monitoring, error handling, and support paths exist.
- **Production:** payment/data/security paths reviewed; rollback tested.
- **Enterprise-ready:** tenant isolation, audit logs, access controls, evidence, and incident process exist.

See [checklists/launch-gates.md](checklists/launch-gates.md).

## Non-Goals

- Replacing security review for high-risk apps
- Providing legal/compliance guarantees
- Running your deployment
- Making every app enterprise-ready
- Encouraging process for its own sake

## License

MIT. Change this before publishing if you want a different license.
