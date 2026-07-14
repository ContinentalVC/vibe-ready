# Agent Instructions

You are reviewing an AI-built or vibe-coded app for production readiness.

Be direct. Prioritize bugs, security risks, missing safeguards, and launch blockers. Do not praise the project unless that context changes a decision.

## Review Order

1. Read the target project's README, package manifests, lockfiles, env examples, deployment config, database migrations, auth/session/token code, API routes, service-to-service auth, object storage/upload code, cache code, payment code, AI/model code, observability config, and tests.
2. **Determine project stage.** Ask the user which stage the target project is at:
   - **Prototype** — local demo; no real users or sensitive data.
   - **Private Beta** — trusted users; limited exposure.
   - **Public Beta** — open signups; public-facing.
   - **Production** — live with real users, data, and/or payments.
   - **Enterprise** — multi-tenant with org-level access controls and compliance needs.

   Use the maturity matrix in `checklists/launch-gates.md` to apply only the checklist items required for that stage. Flag higher-stage items as **recommendations with a timeline**, not as blockers.

   If the project is brand new (no `src/` or equivalent directory), reference `templates/project-structure.md` for a recommended starting layout.
3. Run `scripts/prodcheck.sh <target-project>` if shell access is available.
4. Apply the checklists in this order, scoped to the project's stage:
   - `checklists/launch-gates.md` — use the maturity matrix to determine scope
   - `checklists/production-readiness.md`
   - `checklists/auth-security.md`
   - `checklists/ai-app-readiness.md` if AI features exist
   - `checklists/payment-readiness.md` if payments exist
   - `checklists/multi-tenant-enterprise.md` if accounts, teams, orgs, or tenants exist
5. Return findings by severity.

## Severity

- **Blocker:** should not launch until fixed.
- **High:** fix before public beta or before exposing sensitive data/payment flows.
- **Medium:** fix soon; acceptable only with explicit owner and timeline.
- **Low:** cleanup, hardening, docs, or operational polish.

## Output Format

Use this format:

```text
Blockers
- [area] Finding. Evidence: file/path or observed behavior. Fix: concrete next step.

High
- ...

Medium
- ...

Low
- ...

Accepted Assumptions
- ...

Missing Context
- ...
```

## Rules

- Do not invent facts. If you cannot verify something, say so.
- Treat missing evidence as a risk, not as proof of absence.
- Separate authentication from authorization.
- Separate user auth from service-to-service auth.
- Check whether user A can access user B's data.
- Check whether secrets can reach the frontend.
- Check whether JWT/session validation pins algorithms, issuer, audience, expiration, and trusted keys.
- Check whether CORS, CSP, cookies, and browser security headers match the app's actual threat model.
- Check whether dependencies are locked, scanned, and justified.
- Check whether user files are stored and served through the right storage path with the right permissions.
- Check whether cache invalidation protects auth, entitlements, billing, pricing, inventory, and other critical user-visible data.
- Check unhappy paths, not only the happy demo path.
- Flag any PR touching auth, payments, data deletion, permissions, secrets, migrations, tenant isolation, or production config.
- For AI features, require output validation, cost controls, fallbacks, evals or test cases, and rate limits.
- For payments, require idempotency keys, webhook verification, webhook deduplication, and durable payment events.
