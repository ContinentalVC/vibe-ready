# Auth And Security Checklist

## Authentication

- [ ] Auth is handled by a proven provider or battle-tested library unless there is a documented reason otherwise.
- [ ] Password storage, if applicable, uses accepted password hashing.
- [ ] Sessions expire.
- [ ] Refresh tokens, if used, are protected and revocable.
- [ ] Password reset links expire and are single-use where possible.
- [ ] Login and password reset endpoints have rate limits.

## Authorization

- [ ] Every protected server route checks permissions.
- [ ] User ownership checks are enforced server-side.
- [ ] Role checks are centralized or easy to audit.
- [ ] Row-level security is enabled where the database supports it and the app needs it.
- [ ] User A cannot access user B's data by changing IDs, slugs, URLs, or request bodies.
- [ ] Admin-only operations are protected independently from UI visibility.

## Secrets

- [ ] API keys are not present in frontend bundles.
- [ ] `.env` files are ignored.
- [ ] `.env.example` documents required variables without real values.
- [ ] Secret scanning runs before merge.
- [ ] Exposed keys are rotated.
- [ ] Keys are scoped by environment, permission, endpoint, domain, or IP where supported.

## Common Web Risks

- [ ] User input is validated.
- [ ] Output is encoded to prevent XSS.
- [ ] SQL queries are parameterized or ORM-safe.
- [ ] File uploads validate type, size, and storage permissions.
- [ ] Logs cannot be forged through newline/control-character injection.
- [ ] Dependencies are scanned for known vulnerabilities.
- [ ] Security headers are configured where applicable.

## High-Risk Changes

Require deeper review for changes touching:

- Auth
- Permissions
- Payments
- Data deletion
- Tenant isolation
- Secrets
- Migrations
- Production deployment
- AI tools with write access
