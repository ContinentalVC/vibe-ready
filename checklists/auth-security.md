# Auth And Security Checklist

Reference anchor: aligned with OWASP Top 10 2021, OWASP ASVS-style controls, CWE/SANS Top 25, and practical guidance on encoding vs. encryption vs. tokenization, XSS mitigation, OAuth 2.0 flows, session vs. JWT tradeoffs, DevSecOps integration, and API key/signature security.

## Authentication

- [ ] Auth is handled by a proven provider or battle-tested library unless there is a documented reason otherwise.
- [ ] The auth approach matches the customer and launch gate: simple managed auth for fast-moving products, enterprise SSO/SAML/SCIM where buyers require it, or self-hosted auth only when the team can operate it.
- [ ] If auth is self-hosted, ownership is documented for session storage, key rotation, uptime, account recovery, and security updates.
- [ ] If enterprise customers are in scope, SSO, SAML/OIDC, organization management, audit evidence, and compliance expectations are explicitly accepted or implemented.
- [ ] Password storage, if applicable, uses accepted password hashing (e.g., bcrypt, scrypt, Argon2) with per-password salts. Passwords are never stored in plaintext or as unsalted hashes.
- [ ] Sessions expire.
- [ ] Absolute and idle session lifetimes are defined from the application's risk, and the server—not only client-side activity—enforces expiration.
- [ ] Session IDs or tokens rotate after login, privilege changes, account recovery, and other authentication-boundary changes.
- [ ] Password changes, account recovery, suspected compromise, and user deprovisioning revoke all affected sessions promptly.
- [ ] Users can review and revoke active devices or sessions where the risk warrants it; concurrent-session limits or alerts are a deliberate policy rather than an accidental framework default.
- [ ] Idle-timeout warnings and reauthentication preserve legitimate in-progress work without persisting secrets or sensitive form state insecurely.
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
- [ ] API key format and verification are chosen intentionally. Opaque bearer keys, an identifier-plus-secret pair, or signed requests may be appropriate; keys are high entropy, stored hashed where lookup permits, shown only when needed, scoped, revocable, and distinguishable by environment without encoding sensitive authorization decisions in a user-editable value.
- [ ] API request signatures, if used, bind the required request data and include freshness/replay protection appropriate to the protocol, such as a timestamp, nonce, or unique request ID. The canonicalization and cryptographic algorithm come from a reviewed protocol or provider specification rather than a custom design.

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
- [ ] SSO tokens or assertions are validated by each trust boundary using trusted issuer metadata and keys or a protected introspection flow as appropriate. Services do not trust identity claims merely because a client or upstream gateway supplied them.

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
- [ ] Every third-party browser resource—scripts, styles, fonts, images, frames, analytics, and widgets—has an owner and business reason; unused origins are removed.
- [ ] CSP is introduced with report-only telemetry where needed, violations are reviewed, and enforcement is enabled without broad permanent exceptions such as unnecessary `unsafe-inline` or wildcard sources.
- [ ] External static resources use self-hosting, integrity protection, or another documented supply-chain control where practical.
- [ ] Cookie flags are set appropriately: `HttpOnly`, `Secure`, `SameSite`, path, domain, and expiration.
- [ ] Browser security controls are treated as part of the security model, not as optional polish.
- [ ] XSS mitigation covers both reflective and stored XSS: input validation on ingest, context-aware output encoding on render (HTML, JavaScript, URL, CSS contexts), and strict Content Security Policy to limit script execution.
- [ ] TLS/HTTPS is enforced end-to-end with valid certificates. SSL/TLS termination at the load balancer or reverse proxy is intentional and documented, with TLS re-encryption for internal traffic where sensitive data is involved.
- [ ] Encoding, encryption, and tokenization are used correctly for their distinct purposes: encoding (e.g., Base64, URL encoding) is for data format compatibility, not security; encryption (symmetric or asymmetric keys) is for confidentiality; tokenization (non-sensitive placeholder + secure vault) is for reducing PCI/PII exposure. These are not interchangeable.
- [ ] Network-level security is reviewed: firewall rules (port-based, IP-based, protocol-based, stateful inspection, application-based), VPN usage for administrative access, and defense in depth across network layers.
- [ ] Server-side URL fetches—including webhooks, URL previews, imports, image/PDF processors, callbacks, and AI browsing/retrieval—defend against SSRF with scheme/host allowlists where practical, redirect revalidation, DNS-rebinding controls, private/link-local/loopback blocking, cloud-metadata blocking, egress controls, and strict response size/time limits.
- [ ] API security review covers the entire inventory, including old versions, debug/admin routes, undocumented endpoints, alternate content types, and gateway bypass paths. Hiding a frontend control is never treated as access control.

## Security Verification

- [ ] A dynamic scan or equivalent manual security pass runs against an authorized staging target with production-like configuration and safe test data.
- [ ] Authorization testing tampers with object IDs, user IDs, tenant or organization IDs, roles, and admin routes; database RLS is treated as one layer, not a substitute for API authorization.
- [ ] Authenticated and unauthenticated attack surfaces are both exercised where applicable.
- [ ] Findings from DAST, SAST, dependency, and secret scans have owners, severity, remediation status, and documented false-positive decisions.
- [ ] Security checks run in CI or on a defined recurring schedule; a one-time prelaunch scan is not treated as continuous assurance.

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
- [ ] Infrastructure configuration is versioned and scanned for security misconfigurations where the team controls infrastructure or platform configuration as code.
- [ ] Container images are scanned when containers are used. Base images are minimal, maintained, and pinned according to the deployment's update strategy.
- [ ] Production secrets come from a protected platform secret store, vault, or equivalent control with scoped access and rotation. Environment-variable injection may be the delivery mechanism, but plaintext secret files and broadly readable process/config exposure are avoided.
- [ ] Threat modeling has been performed for the application's attack surface.
- [ ] In microservice architectures, security is enforced at every level of the service communication path (edge, gateway, service-to-service, data store).
- [ ] Third-party vendor security is assessed for critical dependencies: API providers, SDKs, SaaS integrations with access to sensitive data.
