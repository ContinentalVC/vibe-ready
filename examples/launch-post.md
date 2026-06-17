# Launch Post

Drafts for announcing Vibe Ready. Keep the plain, no-hype voice - it reads as more credible to the engineers you want adopting this. Swap in the real repo URL before posting.

---

## Show HN / dev forums (long)

**Show HN: Vibe Ready - a production-readiness checklist for AI-built apps**

AI coding tools get you to a working demo in an afternoon. They don't tell you when that demo is safe to put in front of real users, real data, or real money. I kept seeing the same gap: prototypes that are demo-ready but not production-ready, shipping with client-side-only auth, committed API keys, unverified Stripe webhooks, and LLM output piped straight into SQL.

Vibe Ready is the checklist that lives between "it works on my screen" and "it's live." It's intentionally lightweight - no framework, no SaaS, no account:

- Checklists for auth, secrets, payments, AI/LLM safety, multi-tenancy, and launch gates
- Agent prompts so Claude Code / Codex / Cursor run the review for you and return findings by severity
- A `prodcheck.sh` scanner for the usual footguns (committed secrets, untracked `.env`, missing migrations, secrets in git history)
- Templates for rollback, incident response, risk register, and launch plans

The checklists are anchored to OWASP (Top 10, LLM Top 10 v2025), Google SRE, 12-Factor, and cloud well-architected guidance - practical review scope, not a compliance claim.

There's a sample review of a fictional vibe-coded SaaS app in the repo so you can see exactly what the output looks like before running it on your own code.

It's MIT-licensed. Feedback and checklist contributions welcome - the bar is concrete, inspectable items with low false-positive rates.

[repo link]

---

## X / Twitter (thread)

1/ AI coding tools get you to a demo in an afternoon. They don't tell you when it's safe to put in front of real users, real data, or real money.

Vibe Ready is the checklist between "works on my screen" and "it's live." Open source, MIT. 

2/ The same things go wrong in vibe-coded apps every time:
- auth checked on the client, not the server
- live API keys committed to git
- Stripe webhooks with no signature check
- LLM output dropped straight into SQL / the DOM

3/ So it's a lightweight toolkit you drop into any project:
- checklists (auth, secrets, payments, AI safety, multi-tenant, launch gates)
- prompts so Claude Code / Codex / Cursor run the review for you
- prodcheck.sh to catch the obvious footguns
- rollback / incident templates

4/ Anchored to OWASP (incl. the LLM Top 10), Google SRE, and 12-Factor - practical scope, not a compliance claim. No framework, no SaaS, no signup.

There's a full sample review in the repo so you can see the output first.

[repo link]

---

## LinkedIn / short post

Most apps built with AI coding tools are demo-ready long before they're production-ready - and the gap is where the incidents live: client-side auth, committed secrets, unverified payment webhooks, unvalidated model output.

Vibe Ready is a small open-source toolkit that closes that gap. Checklists, agent prompts, a local secret/footgun scanner, and rollback/incident templates - anchored to OWASP, Google SRE, and 12-Factor. Drop it into any project and have your coding agent run the review.

MIT-licensed, no signup. Sample review and quick start in the repo: [repo link]

---

## One-liner (for a README badge, bio, or DM)

> Vibe Ready - a production-readiness checklist for AI-built apps. The list between "works on my screen" and "it's live."
