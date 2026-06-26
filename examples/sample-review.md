# Sample Review

This is an illustrative Vibe Ready review of a fictional vibe-coded SaaS app, **InvoiceSnap** - a Next.js + Supabase app that lets small teams upload receipts, extract line items with an LLM, and bill customers through Stripe. It was built in a weekend with an agentic coding tool and is about to be shared with paying beta users.

The review follows the format in [`AGENTS.md`](../AGENTS.md): findings grouped by severity, each with evidence and a concrete fix. The code paths are representative of the failure modes Vibe Ready is designed to catch - not a real repository.

**Inputs:** `scripts/prodcheck.sh .` plus an agent pass using the [checklists](../checklists/).

**Target gate:** Private Beta -> Public Beta.

---

```text
Blockers

- [authorization] Receipt and invoice API routes trust a client-supplied team_id and never verify membership server-side. A user can read or bill against any team's data by changing the body. Evidence: app/api/invoices/route.ts uses `const { teamId } = await req.json()` then queries by teamId with the service-role key, bypassing RLS. Fix: derive the team from the authenticated session, check membership server-side, and stop using the service-role key for user-facing reads. (checklists/auth-security.md -> Authorization)

- [secrets] Live Stripe and OpenAI keys are committed. Evidence: `.env.local` is tracked by git (prodcheck.sh: ".env is tracked by git"); STRIPE_SECRET_KEY=<live-stripe-secret> and OPENAI_API_KEY=<openai-secret> appear in commit history (prodcheck.sh history scan). Fix: rotate both keys now, remove the file from history, add `.env*` to `.gitignore`, and move secrets to the host's secret store. (checklists/auth-security.md -> Secrets)

- [payments] The Stripe webhook does not verify signatures and is not idempotent. Evidence: app/api/webhooks/stripe/route.ts parses `req.json()` directly and grants plan access on `checkout.session.completed` with no `stripe.webhooks.constructEvent` and no dedup on event ID. Anyone can POST a forged event to unlock paid features, and retries double-apply credits. Fix: verify the signature with the webhook secret, dedupe by event ID, and make entitlement changes idempotent. (checklists/payment-readiness.md -> Launch Blockers)

- [ai-safety] LLM-extracted fields flow unescaped into SQL and the DOM. Evidence: lib/extract.ts interpolates the model's `vendor_name` straight into a raw SQL string, and the dashboard renders `line_item.note` with `dangerouslySetInnerHTML`. A crafted receipt image can drive SQL injection or stored XSS through the model. Fix: treat model output as untrusted input - schema-validate, use parameterized queries, and render as text. (checklists/ai-app-readiness.md -> Output Safety)

High

- [token-security] JWT verification trusts the token header algorithm instead of pinning the expected algorithm and issuer/audience. Evidence: lib/auth/jwt.ts calls `jwt.verify(token, key)` with no `algorithms`, `issuer`, or `audience` options. A misconfigured key path can become a token-forgery issue. Fix: pin the allowed algorithm, validate issuer/audience/expiration, and load keys only from trusted configuration. (checklists/auth-security.md -> Tokens And Service Auth)

- [authentication] No rate limit on login or password reset. Evidence: app/api/auth/* has no limiter; reset tokens never expire (no `expires_at` checked). Fix: rate-limit auth endpoints and expire reset tokens. (checklists/auth-security.md -> Authentication)

- [supply-chain] JavaScript dependencies are not locked. Evidence: `package.json` exists but there is no `package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`, or `bun.lockb`; prodcheck.sh warns that production installs are not deterministic. Fix: commit the package-manager lockfile and use frozen-lockfile installs in CI and production. (checklists/production-readiness.md -> Dependencies And Supply Chain)

- [ai-safety] No spend ceiling on the extraction endpoint. Evidence: /api/extract calls the model per uploaded page with no per-user quota, no provider spend cap, and no input size limit - a single user can upload a 500-page PDF in a loop. This is OWASP LLM10 "Denial of Wallet." Fix: per-user quotas, a provider budget alert, and an input-size cap. (checklists/ai-app-readiness.md -> Cost Controls)

- [observability] Errors are swallowed; there is no monitoring. Evidence: most catch blocks `console.log(e)` and return 200. No error tracker, no uptime/latency alerting. You will learn about outages from customers. Fix: add structured error logging and one actionable alert on elevated error rate. (checklists/production-readiness.md -> Observability)

- [cache] Paid entitlements are cached for 30 minutes and payment webhooks do not invalidate the cache. Evidence: lib/entitlements.ts uses `cache.set(userId, plan, 1800)`; app/api/webhooks/stripe/route.ts updates the subscription row but never purges or revalidates that key. Canceled or upgraded users can see stale access. Fix: invalidate entitlement cache from webhook events and consider stale-while-revalidate only for non-critical reads. (checklists/production-readiness.md -> Caching And Consistency)

Medium

- [database] Migrations are not version-controlled and one drops a column in the same deploy as the code that stops using it. Evidence: schema changes were applied by hand in the Supabase console; the `legacy_total` drop ships with the refactor that reads `total`. A rollback would break the running version. Fix: commit migrations and split destructive changes into expand-contract steps. (checklists/production-readiness.md -> Database)

- [file-storage] Uploaded receipts are stored as base64 blobs in the primary database. Evidence: `receipts.image_data` is a text column containing the uploaded file body; there is no object storage bucket or signed URL flow. This inflates database size and makes backup/restore slower. Fix: move file bodies to private object storage and keep metadata, owner, and object key in the database. (checklists/production-readiness.md -> Files And Object Storage)

- [reliability] No fallback when the model provider is slow or down. Evidence: /api/extract awaits the provider with no timeout; the upload UI hangs indefinitely on a provider incident. Fix: set a timeout and degrade to "extraction pending." (checklists/ai-app-readiness.md -> Reliability)

- [frontend] The upload form has no loading or error state and allows double-submit. Evidence: components/Upload.tsx fires on click with no disabled state; rapid clicks create duplicate invoices. Fix: disable on submit and surface error/empty states. (checklists/production-readiness.md -> Frontend)

Low

- [deployment] Deploys go straight from a laptop to production with no preview environment. Evidence: README "deploy" step is `vercel --prod`. Fix: add a preview/staging deploy and a documented rollback. (checklists/production-readiness.md -> Deployment)

- [data-protection] Generated invoice PDFs with customer details are stored in a public storage bucket. Evidence: Supabase bucket `invoice-pdfs` is set to public-read. Fix: make the bucket private and serve via signed URLs. (checklists/production-readiness.md -> Data Protection)

- [operations] Only the original builder knows how to restore a failed deploy or purge bad cache entries. Evidence: README has setup instructions but no rollback, cache purge, or incident runbook. Fix: fill out the Vibe Ready rollback and incident templates with owners and verification steps. (checklists/production-readiness.md -> Documentation And Operations)

Accepted Assumptions

- Single-region deployment is acceptable for beta; multi-region is out of scope for this gate.
- Stripe test mode has been exercised for the happy path; failure/dispute paths have not (tracked under payment-readiness).

Missing Context

- No tests were found (prodcheck.sh: "No obvious tests found"), so unhappy-path behavior is unverified rather than confirmed broken.
- Backup/restore for the Supabase database could not be confirmed from the repo; treat as unverified until the team demonstrates a restore.
```

---

## How to read this

- **Blockers** stop the Private Beta launch. In this example, four of them are the canonical vibe-coded failure modes: client-side authorization, committed live keys, an unverified payment webhook, and unvalidated LLM output reaching SQL and the DOM.
- **Accepted Assumptions** and **Missing Context** keep the review honest - Vibe Ready treats *unverified* as a risk to track, not as proof that something is broken or fine.
- Each finding points at the checklist section it came from, so the fix and the standard behind it are one click away.

Re-run the review after fixes, and use [`templates/risk-register.md`](../templates/risk-register.md) to record decisions on anything you accept rather than fix.
