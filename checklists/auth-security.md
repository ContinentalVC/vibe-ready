# Auth And Security Checklist

## Authentication

- [ ] Auth is handled by a proven provider or battle-tested library unless there is a documented reason otherwise.
- [ ] The auth approach matches the customer and launch gate: simple managed auth for fast-moving products, enterprise SSO/SAML/SCIM where buyers require it, or self-hosted auth only when the team can operate it.
- [ ] If auth is self-hosted, ownership is documented for session storage, key rotation, uptime, account recovery, and security updates.
- [ ] If enterprise customers are in scope, SSO, SAML/OIDC, organization management, audit evidence, and compliance expectations are explicitly accepted or implemented.
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

## Tokens And Service Auth

- [ ] JWT verification pins allowed algorithms and rejects `none` or unexpected algorithms.
- [ ] Token validation checks issuer, audience, expiration, not-before time where applicable, and key ID against trusted keys.
- [ ] Signing keys and secrets are rotated through a documented process.
- [ ] Service-to-service auth is separate from user auth.
- [ ] Machine credentials are scoped per service, environment, and permission rather than shared globally.
- [ ] API keys, client credentials, and service tokens are stored server-side, rotated, and logged without secret values.
- [ ] Internal APIs enforce authorization even when traffic originates from another trusted service.

## Common Web Risks

- [ ] User input is validated.
- [ ] Output is encoded to prevent XSS.
- [ ] SQL queries are parameterized or ORM-safe.
- [ ] File uploads validate type, size, and storage permissions.
- [ ] Logs cannot be forged through newline/control-character injection.
- [ ] Dependencies are scanned for known vulnerabilities.
- [ ] Security headers are configured where applicable.
- [ ] CORS uses an explicit origin allowlist and does not combine wildcard origins with credentials.
- [ ] Content Security Policy is defined for apps rendering user, AI, markdown, or third-party content.
- [ ] Cookie flags are set appropriately: `HttpOnly`, `Secure`, `SameSite`, path, domain, and expiration.
- [ ] Browser security controls are treated as part of the security model, not as optional polish.

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
- JWT/session/token handling
- CORS, CSP, cookies, or browser security headers
- Service-to-service credentials or API keys
