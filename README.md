# Vibe Ready

**Production-readiness checks for AI-built and vibe-coded apps.** Ship the prototype, not the incident.

AI coding tools - Claude Code, Codex, Cursor, Lovable, Bolt, v0, Replit - get you to a working demo in an afternoon. What they don't tell you is when that demo is safe to put in front of real users, real data, or real money. Vibe Ready is the checklist that lives between "it works on my screen" and "it's live."

It is a lightweight, agent-native toolkit you drop into any project:

- **A beginner path** - five plain-language sharing stages and a short list of what matters now
- **Checklists** - auth, secrets, payments, AI/LLM safety, multi-tenancy, customer/data operations, and launch gates (staged by maturity)
- **Agent prompts** - so Claude Code, Codex, or Cursor run the review for you
- **A local scanner** - `prodcheck.sh` catches common footguns and separates "fix now" from "save for later"
- **Templates** - rollback, incident response, postmortem, data lifecycle, architecture decisions, dependency resilience, delivery health, env vars, risk register, launch plan, and project structure

It is not a framework, a SaaS platform, or a compliance certification. The checklists are anchored to OWASP (Top 10, LLM Top 10 v2025), Google SRE, 12-Factor, and cloud well-architected guidance - practical review scope, not a standards-compliance claim.

**See it in action:** [a sample review of a vibe-coded SaaS app ->](examples/sample-review.md)

## The Core Idea

AI-generated prototypes are often demo-ready before they are production-ready.

Vibe Ready gives human builders and coding agents a shared definition of "ready":

- Auth works and authorization is enforced.
- Sessions expire, rotate, and revoke correctly.
- Secrets are not exposed.
- Database changes use migrations.
- Backups and rollback are planned.
- Logs and monitoring exist.
- Dependency, cache, upload, storage, and browser-security risks are reviewed.
- AI outputs are validated.
- Costs and rate limits are controlled.
- Payments, webhooks, and tenant boundaries are reviewed.
- Transactional messages, data deletion/retention, async events, and support escalation are operationally owned.
- Risky changes have human approval gates.

## 30-Second Start — No Gate Knowledge Required

Start with [Is My App Safe To Share?](checklists/quick-start.md). Pick the sentence that sounds like your app:

1. It only runs on my computer.
2. I am sharing it with a few people I know.
3. Anyone can sign up.
4. The app runs a real business.
5. Different companies or teams share the app.

If you are unsure, Vibe Ready uses **sharing with a few trusted people** as a helpful default. It will show later-stage work separately instead of asking you to build everything now.

Copy or reference this repo from the project you want to review:

```bash
cd /path/to/your/app
../vibe-ready/scripts/prodcheck.sh .
```

The output uses four plain-language labels:

- **FIX NOW** - expected before sharing at the selected stage.
- **SAVE FOR LATER** - useful later; do not add complexity yet.
- **GOOD** - supporting evidence was found, but an agent still needs to inspect the implementation.
- **NOTE** - a focused checklist may apply.

Then ask your agent:

```text
Read the Vibe Ready AGENTS.md file.
Use the checklists in Vibe Ready's checklists/ directory.
Review this app for launch blockers, production risks, and missing safeguards.
Return only actionable findings grouped by severity.
```

`prodcheck.sh` scans the working tree and the most recent 300 git commits for high-signal secret patterns by default. It also checks for common dependency manifests, lockfiles, environment examples, migrations, tests, and payment, AI, messaging, and API-contract indicators. Feature detection uses code/dependency content as well as filenames; instruction files such as `AGENTS.md` are not treated as proof that the app contains AI.

Choose a different stage when the app's exposure changes:

```bash
../vibe-ready/scripts/prodcheck.sh --stage prototype .
../vibe-ready/scripts/prodcheck.sh --stage public-beta .
../vibe-ready/scripts/prodcheck.sh --stage production .
```

The default mode is advisory and returns success so it does not unexpectedly block a beginner's workflow. Teams that intentionally want CI enforcement can use `--strict`. Machine-readable output is available with `--format json`.

For deeper local history scanning:

```bash
VIBE_READY_HISTORY_COMMITS=1000 ../vibe-ready/scripts/prodcheck.sh .
```

For full secret forensics, use a dedicated tool such as gitleaks or trufflehog.

## Repo Structure

```text
vibe-ready/
  README.md
  AGENTS.md
  references/
    source-map.md
  rules/
    README.md
  checklists/
    README.md
    quick-start.md
    production-readiness.md
    ai-app-readiness.md
    auth-security.md
    payment-readiness.md
    customer-and-business-operations.md
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
    postmortem.md
    data-lifecycle-plan.md
    architecture-decision-record.md
    dependency-resilience-plan.md
    delivery-health.md
    risk-register.md
    project-structure.md
  scripts/
    prodcheck.sh
  tests/
    prodcheck_test.sh
  examples/
    sample-review.md
    launch-post.md
```

## Suggested Workflow

1. Choose the plain-language sharing level in `checklists/quick-start.md` and run `scripts/prodcheck.sh` against the target project. If unsure, use the default Private Beta review.
2. Give the scanner output to your coding agent. Items required now appear as **FIX NOW**; higher-stage work appears as **SAVE FOR LATER**.
3. Have Claude/Codex/Cursor inspect evidence using only the focused checklists that match the app's features. Apply `customer-and-business-operations.md` when the app has real users, personal data, critical email, payments, or customer commitments.
4. Classify findings as launch blockers, pre-launch fixes, post-launch hardening, or accepted risks.
5. Fill out the launch and rollback templates.
6. Re-run the review before release.

## Standards Anchors

The checklists are intentionally practical rather than exhaustive, but they are shaped by common production-readiness themes from OWASP Top 10, OWASP LLM Top 10, OWASP ASVS-style controls, 12-Factor config discipline, cloud well-architected security/reliability guidance, Google SRE production-readiness practices, and the architecture/reliability/delivery sources in the [source map](references/source-map.md).

These references are anchors for terminology and review scope, not a compliance claim.

## Launch Gates

Reviews are scoped to the project's current stage — not everything is required from day 1. The beginner path in `checklists/quick-start.md` is the primary entry point; the maturity matrix in `checklists/launch-gates.md` routes coding agents into deeper, feature-specific review.

Default gates:

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
- Providing legal, tax, insurance, privacy, or compliance advice
- Replacing product marketing, pricing, social proof, or customer-acquisition strategy

## Acknowledgments

See [ACKNOWLEDGMENTS.md](ACKNOWLEDGMENTS.md).

## License

MIT. Change this before publishing if you want a different license.
