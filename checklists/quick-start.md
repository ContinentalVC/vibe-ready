# Start Here: Is My App Safe To Share?

You do not need to understand every software term in this repository.

Pick the sentence that best describes your app. Start there, fix only the items in that section and the sections above it, then ask your coding agent to inspect the evidence. The longer checklists are reference material for the agent—not homework you must complete alone.

## 1. It Only Runs On My Computer — Prototype

- [ ] I am using fake data, not real customer or sensitive data.
- [ ] No real API keys, passwords, or payment credentials are committed to Git.
- [ ] Anyone seeing the demo is told that it is not production-ready.

Run:

```bash
scripts/prodcheck.sh --stage prototype /path/to/my-app
```

## 2. I Am Sharing It With A Few People I Know — Private Beta

This is Vibe Ready's default because it is the most useful next step for many early apps.

- [ ] People must sign in before seeing private information.
- [ ] The server checks that each person owns or may access the record they request. Hiding a button is not enough.
- [ ] Dependencies are locked, required environment variables are documented, and local `.env*` files are ignored by Git.
- [ ] Database changes are saved as migrations, and user-created data has a backup.
- [ ] Errors are logged without showing secrets or technical stack traces to users.
- [ ] There is a written way to undo a bad deploy.
- [ ] Expensive, login, password-reset, upload, payment, and AI endpoints cannot be spammed without limits.
- [ ] At least one automated test covers the main user journey and one likely failure.
- [ ] A real person owns support when a tester gets locked out, charged incorrectly, or loses data.

Run:

```bash
scripts/prodcheck.sh /path/to/my-app
```

## 3. Anyone Can Sign Up — Public Beta

- [ ] Someone is alerted when the app is down or important actions fail.
- [ ] Dependency, secret, and basic web-security scans run regularly.
- [ ] Risky or expensive features can be turned off without taking down the whole app.
- [ ] Account deletion and data retention are defined if personal data is collected.
- [ ] Unhappy paths—timeouts, duplicate clicks, bad input, permission tampering, and third-party failures—are tested.
- [ ] If the app uses AI, payments, uploads, email, or teams, the matching focused checklist has been reviewed.

Run:

```bash
scripts/prodcheck.sh --stage public-beta /path/to/my-app
```

## 4. The App Runs A Real Business — Production

- [ ] Backup restoration and deploy rollback have been performed successfully, not merely documented.
- [ ] Expected traffic, credible traffic spikes, slow dependencies, and dependency outages have been tested or accepted explicitly.
- [ ] Important user journeys have a reliability target and useful alerts.
- [ ] An incident owner, support owner, and post-launch monitoring plan are named.
- [ ] Architecture decisions explain why each database, cache, queue, service, or gateway is needed. Missing components are not added just because a diagram says production apps have them.
- [ ] Delivery health is measured so changes can become both safer and easier over time.

Run:

```bash
scripts/prodcheck.sh --stage production /path/to/my-app
```

## 5. Different Companies Or Teams Share The App — Enterprise

- [ ] Cross-tenant tests prove one company cannot access another company's data.
- [ ] Roles, invitations, removals, support access, and sensitive exports are permissioned and audited.
- [ ] Enterprise identity, deletion/export evidence, incident response, and customer security claims match what the product actually supports.

Run:

```bash
scripts/prodcheck.sh --stage enterprise /path/to/my-app
```

## What The Scanner Words Mean

- **FIX NOW:** expected for the stage you chose. Ask your coding agent to verify and fix it.
- **SAVE FOR LATER:** useful at a later stage. Record it; do not add complexity yet.
- **GOOD:** a useful signal was found. It is not proof that the implementation is secure.
- **NOTE:** a feature may exist or a focused review may apply.

The scanner stays non-blocking by default. Teams that deliberately want CI enforcement can add `--strict`, which exits with status 3 when a **FIX NOW** item exists.
