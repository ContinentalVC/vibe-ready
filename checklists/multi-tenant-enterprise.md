# Multi-Tenant And Enterprise Readiness

Use this when the app has teams, organizations, workspaces, customers, accounts, or tenants.

## Tenant Isolation

- [ ] Isolation model is documented: shared schema with RLS, schema per tenant, or database per tenant.
- [ ] Tenant ID is enforced server-side.
- [ ] User-controlled tenant IDs are not trusted.
- [ ] Cross-tenant access tests exist.
- [ ] Admin/support impersonation is logged and permissioned.

## Access Control

- [ ] Roles and permissions are documented.
- [ ] Invitations, membership changes, and removals are tested.
- [ ] Former users lose access immediately.
- [ ] Sensitive exports require permission checks.
- [ ] API keys or service accounts are scoped to a tenant where applicable.
- [ ] Enterprise SSO/SAML/OIDC requirements are implemented or explicitly out of scope.
- [ ] Each tenant's SSO configuration, identity-provider metadata, certificates, client secrets, domains, and attribute mappings are isolated and bound to the intended tenant.
- [ ] SSO validation checks trusted issuer, audience, destination or redirect URI, signature, time conditions, replay protections, and tenant binding as applicable to the protocol.
- [ ] Just-in-time provisioning, invitations, SCIM or equivalent deprovisioning, group-to-role mapping, and break-glass access have explicit policies and tests.
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
- [ ] Procurement and security-questionnaire answers link to current evidence rather than unsupported claims.
- [ ] Any public security or trust page names a vulnerability-reporting contact and makes only claims the organization can prove.
