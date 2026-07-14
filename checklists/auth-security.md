# Auth And Security Checklist

Reference anchor: aligned with OWASP Top 10 2021, OWASP ASVS-style controls, CWE/SANS Top 25, and practical guidance on encoding vs. encryption vs. tokenization, XSS mitigation, OAuth 2.0 flows, session vs. JWT tradeoffs, DevSecOps integration, and API key/signature security.

## Authentication

- [ ] Auth is handled by a proven provider or battle-tested library unless there is a documented reason otherwise.
- [ ] The auth approach matches the customer and launch gate: simple managed auth for fast-moving products, enterprise SSO/SAML/SCIM where buyers require it, or self-hosted auth only when the team can operate it.
- [ ] If auth is self-hosted, ownership is documented for session storage, key rotation, uptime, account recovery, and security updates.
- [ ] If enterprise customers are in scope, SSO, SAML/OIDC, organization management, audit evidence, and compliance expectations are explicitly accepted or implemented.
- [ ] Password storage, if applicable, uses accepted password hashing (e.g., bcrypt, scrypt, Argon2) with per-password salts. Passwords are never stored in plaintext or as unsalted hashes.
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
- [ ] API key generation, if implemented, pairs a public key (access key) with a private key (secret key). Different key pairs are used for different authorization levels (e.g., read-only vs. read-write).
- [ ] API request signatures, if used, include: authentication credentials, a timestamp (to prevent replay attacks), request-specific data, and a nonce (random string ensuring request uniqueness). The signature is generated using HMAC-SHA256 or equivalent with the secret key.

## Tokens And Service Auth

- [ ] JWT verification pins allowed algorithms and rejects `none` or unexpected algorithms.
- [ ] Token validation checks issuer, audience, expiration, not-before time where applicable, and key ID against trusted keys.
- [ ] Signing keys and secrets are rotated through a documented process.
- [ ] Service-to-service auth is separate from user auth.
- [ ] Machine credentials are scoped per service, environment, and permission rather than shared globally.
- [ ] API keys, client credentials, and service tokens are stored server-side, rotated, and logged without secret values.
- [ ] Internal APIs enforce authorization even when traffic originates from another trusted service.
- [ ] The auth approach (session-based vs. JWT-based) is chosen with documented tradeoffs. Session-based: state stored server-side, easy revocation, but requires session store lookup on every request. JWT-based: stateless, no server session needed, but token revocation is harder and tokens carry more data.
- [ ] If OAuth 2.0 is used, the correct flow is chosen: Authorization Code Flow (with PKCE for public clients) for web/mobile apps, Client Credentials Flow for machine-to-machine, not Implicit Flow or Resource Owner Password Grant for user-facing apps unless there is a documented legacy reason.
- [ ] SSO, if implemented, uses a central authentication server with token-based validation across services. The SSO token is validated by each service against the auth server, not trusted blindly from the client.

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
- [ ] XSS mitigation covers both reflective and stored XSS: input validation on ingest, context-aware output encoding on render (HTML, JavaScript, URL, CSS contexts), and strict Content Security Policy to limit script execution.
- [ ] TLS/HTTPS is enforced end-to-end with valid certificates. SSL/TLS termination at the load balancer or reverse proxy is intentional and documented, with TLS re-encryption for internal traffic where sensitive data is involved.
- [ ] Encoding, encryption, and tokenization are used correctly for their distinct purposes: encoding (e.g., Base64, URL encoding) is for data format compatibility, not security; encryption (symmetric or asymmetric keys) is for confidentiality; tokenization (non-sensitive placeholder + secure vault) is for reducing PCI/PII exposure. These are not interchangeable.
- [ ] Network-level security is reviewed: firewall rules (port-based, IP-based, protocol-based, stateful inspection, application-based), VPN usage for administrative access, and defense in depth across network layers.

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

## DevSecOps And Security Integration

- [ ] Security is integrated into the CI/CD pipeline: automated security checks, dependency vulnerability scanning, secret scanning, and SAST/DAST run before merge or deploy.
- [ ] Infrastructure is defined as code (IaC) and scanned for security misconfigurations.
- [ ] Container images are scanned for vulnerabilities. Base images are minimal, up-to-date, and pinned.
- [ ] Secret management uses a dedicated vault or secrets manager rather than environment variables alone for sensitive values.
- [ ] Threat modeling has been performed for the application's attack surface.
- [ ] In microservice architectures, security is enforced at every level of the service communication path (edge, gateway, service-to-service, data store).
- [ ] Third-party vendor security is assessed for critical dependencies: API providers, SDKs, SaaS integrations with access to sensitive data.
