# Vibe Ready

**Production-readiness checks for AI-built and vibe-coded apps.** Ship the prototype, not the incident.

AI coding tools - Claude Code, Codex, Cursor, Lovable, Bolt, v0, Replit - get you to a working demo in an afternoon. What they don't tell you is when that demo is safe to put in front of real users, real data, or real money. Vibe Ready is the checklist that lives between "it works on my screen" and "it's live."

It is a lightweight, agent-native toolkit you drop into any project:

- **Checklists** - auth, secrets, payments, AI/LLM safety, multi-tenancy, and launch gates
- **Agent prompts** - so Claude Code, Codex, or Cursor run the review for you
- **A local scanner** - `prodcheck.sh` catches the usual footguns: committed secrets, untracked `.env`, missing migrations, missing lockfiles
- **Templates** - rollback, incident response, env vars, risk register, launch plan

It is not a framework, a SaaS platform, or a compliance certification. The checklists are anchored to OWASP (Top 10, LLM Top 10 v2025), Google SRE, 12-Factor, and cloud well-architected guidance - practical review scope, not a standards-compliance claim.

**See it in action:** [a sample review of a vibe-coded SaaS app ->](examples/sample-review.md)

## The Core Idea

AI-generated prototypes are often demo-ready before they are production-ready.

Vibe Ready gives human builders and coding agents a shared definition of "ready":

- Auth works and authorization is enforced.
- Secrets are not exposed.
- Database changes use migrations.
- Backups and rollback are planned.
- Logs and monitoring exist.
- Dependency, cache, upload, storage, and browser-security risks are reviewed.
- AI outputs are validated.
- Costs and rate limits are controlled.
- Payments, webhooks, and tenant boundaries are reviewed.
- Risky changes have human approval gates.

## 30-Second Start

Copy or reference this repo from the project you want to review:

```bash
cd /path/to/your/app
../vibe-ready/scripts/prodcheck.sh .
```

Then ask your agent:

```text
Read the Vibe Ready AGENTS.md file.
Use the checklists in Vibe Ready's checklists/ directory.
Review this app for launch blockers, production risks, and missing safeguards.
Return only actionable findings grouped by severity.
```

`prodcheck.sh` scans the working tree and the most recent 300 git commits for high-signal secret patterns by default. It also checks for common dependency manifests, lockfiles, environment examples, migrations, tests, and payment/AI indicators. For deeper local history scanning:

```bash
VIBE_READY_HISTORY_COMMITS=1000 ../vibe-ready/scripts/prodcheck.sh .
```

For full secret forensics, use a dedicated tool such as gitleaks or trufflehog.

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
  examples/
    sample-review.md
    launch-post.md
```

## Suggested Workflow

1. Run `scripts/prodcheck.sh` against the target project.
2. Have Claude/Codex/Cursor perform a checklist-based review.
3. Classify findings as launch blockers, pre-launch fixes, post-launch hardening, or accepted risks.
4. Fill out the launch and rollback templates.
5. Re-run the review before release.

## Standards Anchors

The checklists are intentionally practical rather than exhaustive, but they are shaped by common production-readiness themes from OWASP Top 10 2021, OWASP LLM Top 10 v2025, OWASP ASVS-style controls, 12-Factor config discipline, cloud well-architected security/reliability guidance, and Google SRE production-readiness practices.

These references are anchors for terminology and review scope, not a compliance claim.

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

## Acknowledgments

See [ACKNOWLEDGMENTS.md](ACKNOWLEDGMENTS.md).

## License

MIT. Change this before publishing if you want a different license.
