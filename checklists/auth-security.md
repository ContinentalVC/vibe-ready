# Auth And Security Checklist

Reference anchor: aligned with OWASP Top 10 2021, OWASP ASVS-style controls, CWE/SANS Top 25, and practical guidance on encoding vs. encryption vs. tokenization, XSS mitigation, OAuth 2.0 flows, session vs. JWT tradeoffs, DevSecOps integration, and API key/signature security.

## Authentication

- [ ] Auth is handled by a proven provider or battle-tested library unless there is a documented reason otherwise.
- [ ] The auth approach matches the customer and launch gate: simple managed auth for fast-moving products, enterprise SSO/SAML/SCIM where buyers require it, or self-hosted auth only when the team can operate it.
- [ ] If auth is self-hosted, ownership is documented for session storage, key rotation, uptime, account recovery, and security updates.
- [ ] If enterprise customers are in scope, SSO, SAML/OIDC, organization management, audit evidence, and compliance expectations are explicitly accepted or implemented.
- [ ] Password storage, if applicable, uses accepted password hashing (e.g., bcrypt, scrypt, Argon2) with per-password salts. Passwords are never stored in plaintext or as unsalted hashes.
- [ ] Sessions expire.
- [ ] The session identifier is regenerated on login and on any privilege change (role promotion, plan upgrade, starting or ending impersonation), not only invalidated at logout.
- [ ] Idle and absolute session timeouts are both defined. Idle timeout is measured from real user activity (navigation, submits, API calls) rather than cursor movement, warns before expiry, and preserves unsaved work across re-authentication.
- [ ] Refresh tokens, if used, are protected and revocable.
- [ ] Password reset links expire and are single-use where possible.
- [ ] Login and password reset endpoints have rate limits.
- [ ] Multi-factor authentication is available to all users and required for admin, support, and other privileged accounts. Account recovery and support-assisted resets do not bypass it.
- [ ] Passwordless sign-in links and one-time codes expire within minutes, are single-use, and are invalidated on first use. Requests are rate limited per address and per source IP, because each request sends real email from your domain and can flood a victim's inbox or damage sender reputation.
- [ ] Post-login, post-logout, and post-reset redirect targets are validated against an allowlist. Redirect values are parsed as URLs rather than string-matched, so protocol-relative (`//host`), backslash, and encoded variants are rejected.

## Authorization

- [ ] Every protected server route checks permissions.
- [ ] Authorization is enforced per route on the server, not only in edge or framework middleware. Middleware matchers are audited for excluded paths, trailing-slash and encoded-path variants, and for checking that a session cookie is present rather than valid.
- [ ] User ownership checks are enforced server-side.
- [ ] Role checks are centralized or easy to audit.
- [ ] Row-level security is enabled where the database supports it and the app needs it.
- [ ] User A cannot access user B's data by changing IDs, slugs, URLs, or request bodies.
- [ ] Write endpoints accept an explicit allowlist of client-writable fields and reject unknown or privileged fields such as `role`, `isAdmin`, `plan`, or `accountStatus`. Tests assert those fields are rejected, not silently ignored.
- [ ] Admin-only operations are protected independently from UI visibility.
- [ ] Admin and elevated operations live on separate routes with their own authorization rather than on shared endpoints distinguished by a request field.
- [ ] Identifiers exposed to clients are non-enumerable (UUIDs or opaque IDs) wherever sequential IDs would let one authorized caller walk an entire table.
- [ ] Responses return only the fields the client actually renders. Internal IDs, related-user records, and unused personal data are removed at the serialization layer, not just hidden in the UI.

## Secrets

- [ ] API keys are not present in frontend bundles.
- [ ] `.env` files are ignored.
- [ ] `.env.example` documents required variables without real values.
- [ ] Artifacts produced by AI coding tools are kept out of version control, and agent-authored commits are reviewed before they are pushed. Screenshots, screen recordings, session transcripts, debug dumps, and tool cache directories can capture credentials, customer data, and internal dashboards, and are easy to commit to a public repository unnoticed.
- [ ] Permissions granted to AI coding assistants (screen capture, filesystem scope, network access, push rights) are limited to what the task needs and reviewed periodically. Repository visibility is verified for every repository those tools can push to.
- [ ] Secret scanning runs before merge.
- [ ] The production build output is inspected for secrets and server-only values, not just the source tree. Framework server/client boundaries are verified rather than assumed.
- [ ] Server-only modules are marked so that importing them from client code fails the build where the framework supports it.
- [ ] Exposed keys are rotated.
- [ ] Keys are scoped by environment, permission, endpoint, domain, or IP where supported.
- [ ] API key generation, if implemented, pairs a public key (access key) with a private key (secret key). Different key pairs are used for different authorization levels (e.g., read-only vs. read-write).
- [ ] API request signatures, if used, include: authentication credentials, a timestamp (to prevent replay attacks), request-specific data, and a nonce (random string ensuring request uniqueness). The signature is generated using HMAC-SHA256 or equivalent with the secret key.

## Tokens And Service Auth

- [ ] JWT verification pins allowed algorithms and rejects `none` or unexpected algorithms.
- [ ] Token validation checks issuer, audience, expiration, not-before time where applicable, and key ID against trusted keys.
- [ ] Signing keys and secrets are rotated through a documented process.
- [ ] Auth tokens are not kept in `localStorage`, `sessionStorage`, or other script-readable browser storage where an `HttpOnly`, `Secure`, `SameSite` cookie is viable.
- [ ] Service-to-service auth is separate from user auth.
- [ ] Machine credentials are scoped per service, environment, and permission rather than shared globally.
- [ ] API keys, client credentials, and service tokens are stored server-side, rotated, and logged without secret values.
- [ ] Internal APIs enforce authorization even when traffic originates from another trusted service.
- [ ] Services are network-segmented so each can reach only the services it needs. A low-trust component such as a marketing tool, admin UI, or worker cannot open a connection straight to the production database or to other internal services.
- [ ] Internal service-to-service calls authenticate with mutual TLS or service tokens. Network location alone is never treated as proof of identity.
- [ ] Each container, service account, and network rule has the minimum privilege its job requires: database credentials are read-only where writes are not needed, and services that do not need outbound internet access cannot make it.
- [ ] The auth approach (session-based vs. JWT-based) is chosen with documented tradeoffs. Session-based: state stored server-side, easy revocation, but requires session store lookup on every request. JWT-based: stateless, no server session needed, but token revocation is harder and tokens carry more data.
- [ ] If OAuth 2.0 is used, the correct flow is chosen: Authorization Code Flow (with PKCE for public clients) for web/mobile apps, Client Credentials Flow for machine-to-machine, not Implicit Flow or Resource Owner Password Grant for user-facing apps unless there is a documented legacy reason.
- [ ] SSO, if implemented, uses a central authentication server with token-based validation across services. The SSO token is validated by each service against the auth server, not trusted blindly from the client.

## Common Web Risks

- [ ] User input is validated. Validation that exists in the client is duplicated server-side, and the server rejects fields the schema does not declare.
- [ ] Output is encoded to prevent XSS.
- [ ] SQL queries are parameterized or ORM-safe.
- [ ] Raw-SQL escape hatches inside an ORM are audited individually. Parameterization is verified per query rather than assumed because an ORM is in use.
- [ ] Framing is controlled with `X-Frame-Options` and a CSP `frame-ancestors` directive, scoped per route where a surface is intentionally embeddable.
- [ ] GraphQL endpoints, if present, disable introspection and field suggestions in production, enforce query depth and complexity limits, and return generic errors.
- [ ] Server-side fetches of user- or model-supplied URLs use an outbound domain allowlist, block private and link-local ranges including cloud metadata endpoints, re-validate the resolved address on every redirect hop, and return uniform errors so failures cannot be used to map internal services.
- [ ] User-supplied content rendered into transactional email is escaped or sent as plain text. Templates are tested with markup in every user-controlled field, because a domain that passes SPF/DKIM/DMARC will deliver attacker-authored links for you.
- [ ] File uploads validate type, size, and storage permissions.
- [ ] Logs cannot be forged through newline/control-character injection.
- [ ] Dependencies are scanned for known vulnerabilities.
- [ ] Security headers are configured where applicable.
- [ ] CORS uses an explicit origin allowlist and does not combine wildcard origins with credentials.
- [ ] The request `Origin` header is checked against the allowlist before it is reflected into `Access-Control-Allow-Origin`, and credentials are enabled only for matched origins. Echoing the origin back unchecked is functionally a wildcard, and it passes scanners that only look for `*`.
- [ ] Content Security Policy is defined for apps rendering user, AI, markdown, or third-party content.
- [ ] Every externally loaded browser resource is inventoried and justified: scripts, stylesheets, fonts, tracking pixels, and iframes. Anything that cannot be explained is removed.
- [ ] Third-party scripts are kept off login, checkout, account settings, and admin pages, so a compromised vendor cannot read credentials or payment input.
- [ ] Content Security Policy is deployed in report-only mode first, with violations collected and reviewed before enforcement is turned on.
- [ ] Cookie flags are set appropriately: `HttpOnly`, `Secure`, `SameSite`, path, domain, and expiration.
- [ ] Browser security controls are treated as part of the security model, not as optional polish.
- [ ] XSS mitigation covers both reflective and stored XSS: input validation on ingest, context-aware output encoding on render (HTML, JavaScript, URL, CSS contexts), and strict Content Security Policy to limit script execution.
- [ ] TLS/HTTPS is enforced end-to-end with valid certificates. SSL/TLS termination at the load balancer or reverse proxy is intentional and documented, with TLS re-encryption for internal traffic where sensitive data is involved.
- [ ] Encoding, encryption, and tokenization are used correctly for their distinct purposes: encoding (e.g., Base64, URL encoding) is for data format compatibility, not security; encryption (symmetric or asymmetric keys) is for confidentiality; tokenization (non-sensitive placeholder + secure vault) is for reducing PCI/PII exposure. These are not interchangeable.
- [ ] Network-level security is reviewed: firewall rules (port-based, IP-based, protocol-based, stateful inspection, application-based), VPN usage for administrative access, and defense in depth across network layers.

## Mobile And Native Clients

Use this section when the product ships an app store build, including web apps wrapped in a native shell.

- [ ] Tokens and keys are stored in the platform secure store (iOS Keychain, Android Keystore) rather than app-local plaintext files, preferences, or web storage inside a WebView wrapper.
- [ ] The shipped binary is treated as public. No secret is embedded in the bundle on the assumption that users cannot extract it.
- [ ] Certificate pinning is applied to sensitive traffic where the threat model justifies the operational cost of rotation.
- [ ] Deep-link and custom-scheme handlers validate the origin and integrity of what they receive, so another installed app cannot intercept or forge an auth callback.
- [ ] Sensitive fields are encrypted within the payload where transport encryption alone is not sufficient.

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
- Redirect handling and session lifecycle
- Server-side fetching of user- or model-supplied URLs
- Which fields a client is allowed to write
- Third-party scripts added to credential or payment pages

## DevSecOps And Security Integration

- [ ] Security is integrated into the CI/CD pipeline: automated security checks, dependency vulnerability scanning, secret scanning, and SAST/DAST run before merge or deploy.
- [ ] The default branch is protected: direct pushes are blocked, merges require review, and failing checks block the merge. An agent cannot land a large unreviewed change straight onto main.
- [ ] Self-managed hosts are hardened: key-based SSH only, root login disabled, default-deny inbound firewall with datastore ports closed to the internet, and automatic security patching for the OS.
- [ ] Datastores that hold sessions or identity (Redis, Memcached, and similar) require credentials, restrict the command set the application needs, and accept connections only from the application's network.
- [ ] Infrastructure is defined as code (IaC) and scanned for security misconfigurations.
- [ ] Container images are scanned for vulnerabilities. Base images are minimal, up-to-date, and pinned.
- [ ] Secret management uses a dedicated vault or secrets manager rather than environment variables alone for sensitive values.
- [ ] Threat modeling has been performed for the application's attack surface.
- [ ] In microservice architectures, security is enforced at every level of the service communication path (edge, gateway, service-to-service, data store).
- [ ] Third-party vendor security is assessed for critical dependencies: API providers, SDKs, SaaS integrations with access to sensitive data.
