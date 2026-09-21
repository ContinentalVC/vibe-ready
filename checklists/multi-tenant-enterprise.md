# Multi-Tenant And Enterprise Readiness

Use this when the app has teams, organizations, workspaces, customers, accounts, or tenants.

## Tenant Isolation

- [ ] Isolation model is documented: shared schema with RLS, schema per tenant, or database per tenant.
- [ ] Tenant ID is enforced server-side.
- [ ] User-controlled tenant IDs are not trusted.
- [ ] Tenant scoping is verified in every shared layer, not only the database: cache keys, search indexes, job queue payloads, object storage paths, log streams, vector stores, and exports. Row-level security does not help if a cache key omits the tenant.
- [ ] Cross-tenant access tests exist.
- [ ] Cross-tenant tests cover those shared layers too, not only direct API access with a swapped ID.
- [ ] Per-tenant customization lives in configuration or an extension layer rather than forked repositories or per-client columns on shared tables.
- [ ] Admin/support impersonation is logged and permissioned.

## Access Control

- [ ] Roles and permissions are documented.
- [ ] Invitations, membership changes, and removals are tested.
- [ ] Former users lose access immediately.
- [ ] Sensitive exports require permission checks.
- [ ] API keys or service accounts are scoped to a tenant where applicable.
- [ ] Enterprise SSO/SAML/OIDC requirements are implemented or explicitly out of scope.
- [ ] Organization membership, domain capture, and account takeover edge cases are tested where applicable.
- [ ] Minimal data permissions are enforced via RBAC. Users have access only to the information and resources necessary for their roles.
- [ ] Data lifecycle management is defined: permissions granted during development are revoked when data goes live; data access is auditable and time-bounded where appropriate.
- [ ] Sensitive data desensitization or anonymization is applied when sharing data externally or across tenants.

## Enterprise Evidence

- [ ] Audit logs cover sensitive actions.
- [ ] Audit logs identify actor, tenant, target object, timestamp, IP/user agent where appropriate, and before/after state for critical changes.
- [ ] Backup and restore process is documented.
- [ ] Restore has been tested and evidence is available for customer or auditor review where enterprise sales require it.
- [ ] Incident response process exists.
- [ ] Data deletion and export processes exist.
- [ ] Privacy policy and terms are present.
- [ ] Security contact or support process is defined.
- [ ] SOC 2, security questionnaire, DPA, subprocessors, and vulnerability management expectations are either supported or recorded as not yet available.
- [ ] Whether the product handles regulated data (health, financial, education, biometric, children's data) is determined explicitly rather than assumed, because the obligations attach to the data, not to the company's size.
- [ ] Where regulated data is in scope, the required agreements are signed with every vendor that can access it, and the data is kept out of application logs, exports, and analytics pipelines — not merely encrypted in the primary datastore.
- [ ] Regulatory scope is evaluated against where users are located, not only where the company operates.
- [ ] Commercial terms match what is being sold: a service agreement stating uptime and response commitments, and liability coverage appropriate to the contracts being signed.
- [ ] The dependency on any single platform (auth provider, database host, model vendor) is understood, including what migrating off it would cost if pricing, terms, or service levels change.
