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
- [ ] Organization membership, domain capture, and account takeover edge cases are tested where applicable.

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
