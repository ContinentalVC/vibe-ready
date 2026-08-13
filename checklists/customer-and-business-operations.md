# Customer And Business Operations Checklist

Use this when an app has real users, sends transactional messages, accepts payments, stores personal data, or makes claims to customers or enterprise buyers.

This checklist is operational guidance, not legal, tax, insurance, or compliance advice. Requirements vary by jurisdiction, industry, contract, provider, and data type. Record the applicable basis and have qualified professionals review material obligations.

Reference anchors: current [Gmail sender requirements](https://support.google.com/mail/answer/81126), official processor documentation such as [Stripe's payment-retry guidance](https://docs.stripe.com/billing/revenue-recovery/smart-retries), and primary legal text such as the [official GDPR publication](https://eur-lex.europa.eu/eli/reg/2016/679/oj/eng). These are examples, not universal rules; verify the sources that apply to the product.

## Account And Data Lifecycle

- [ ] A data map identifies every store tied to a person or account: primary tables, uploads, sessions, support records, analytics, caches, search indexes, backups, exports, and third-party processors.
- [ ] Account deactivation, access revocation, soft deletion, anonymization, legal hold, retention, and permanent deletion are separate states with explicit transitions.
- [ ] Deleting an account revokes access and active sessions promptly even when some records must be retained.
- [ ] Cascade behavior is defined for every related object; shared, financial, fraud-prevention, and legally required records are not deleted accidentally.
- [ ] Retention periods have a documented legal, contractual, security, or operational basis. AI-generated timelines and generic defaults are not treated as authority.
- [ ] Privacy requests are authenticated, tracked, fulfilled within the applicable deadline, and tested end to end for export, correction, restriction, and deletion where relevant.
- [ ] Deletion propagates to caches, indexes, object storage, analytics, and processors; backup handling and restoration re-deletion are documented.
- [ ] The audit trail proves state changes and policy execution without retaining the erased personal content itself unnecessarily.
- [ ] Legal holds override routine deletion only through an authorized, logged, time-bounded process.

## Transactional Messaging

- [ ] Sending domains meet current recipient-provider authentication requirements, including SPF, DKIM, DMARC, alignment, DNS, and TLS as applicable to the sender's volume and destinations.
- [ ] Transactional, security, and marketing message streams have intentional sender identities and reputation isolation where appropriate.
- [ ] Password resets, login alerts, receipts, payment failures, deletion confirmations, and other critical messages are tested with production-like domains and major recipient providers.
- [ ] Delivery events, bounces, suppressions, complaints, provider rejection, and domain reputation are monitored; an API response marked `delivered` is not assumed to mean inbox placement.
- [ ] Critical actions have an in-app status, downloadable record, or support fallback when email is delayed or rejected.
- [ ] Message retries are bounded and idempotent; duplicate jobs do not send confusing or contradictory notices.
- [ ] Transactional messages do not contain unnecessary secrets or sensitive data, and links expire or require reauthentication where appropriate.
- [ ] Marketing consent, unsubscribe, suppression, and retention behavior follow applicable law and recipient-provider rules and do not break required transactional mail.

## Support And Customer Signals

- [ ] A support channel, owner, service expectation, and escalation path exist for the current launch stage.
- [ ] Playbooks cover common access, billing, configuration, deletion, and incident cases and are tested against real failure paths.
- [ ] Automation hands off contested, consequential, ambiguous, or repeatedly unresolved cases to a human with sufficient context.
- [ ] Tickets are classified by root cause—user understanding, platform failure, business-logic defect, third-party failure, or policy issue—rather than only by symptom.
- [ ] Repeated ticket patterns create product, observability, documentation, or engineering follow-ups with an owner.
- [ ] Support reports complement synthetic checks and telemetry; neither support nor infrastructure monitoring is treated as sufficient alone.
- [ ] Administrative support actions such as refunds, impersonation, entitlement changes, and data exports are permissioned and audited.

## Product Telemetry

- [ ] Critical funnel and retention events represent meaningful product outcomes rather than vanity metrics such as cumulative signups alone.
- [ ] Event names, schemas, ownership, consent basis, and retention are documented; analytics does not collect unnecessary personal or sensitive data.
- [ ] Cohort, activation, retention, and drop-off definitions are stable enough to compare over time.
- [ ] Alerts exist for abnormal failure or abandonment in critical journeys such as signup, checkout, onboarding, account recovery, and cancellation.
- [ ] Automated re-engagement respects consent and frequency limits and does not expose private activity in message content.

## Commercial, Tax, And Trust Readiness

- [ ] Terms, privacy notices, refund and cancellation policy, data-processing terms, service commitments, and acceptable-use terms match the product's actual behavior and customer type.
- [ ] Material legal documents and regulated-industry obligations are reviewed by qualified counsel; AI drafts and downloaded templates are starting points, not approval.
- [ ] Applicable sales tax, VAT, nexus, invoicing, registration, collection, remittance, and filing duties are reviewed with a qualified tax professional and configured in the payment stack where required.
- [ ] Filing and renewal obligations have an owner, evidence, and calendar rather than relying on memory or processor defaults.
- [ ] Security questionnaires, trust-page claims, uptime or SLA promises, data-location statements, and compliance claims are evidence-backed and kept current.
- [ ] A vulnerability-reporting and security-contact path exists before publishing a security page or selling to security-reviewed customers.
- [ ] Appropriate business and cyber insurance are considered against actual exposure with a qualified broker; coverage is not assumed from incorporation or contracts.

## Out Of Scope For Launch Blocking

Pricing, social proof, audience building, and customer-acquisition tactics can determine business success, but they are not production-safety controls. Track them separately unless a claim, consent flow, or customer promise creates a concrete operational or legal risk.
