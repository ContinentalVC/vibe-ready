# Focused Checklist Router

Builders should begin with [`quick-start.md`](quick-start.md). Coding agents use this page to open only the deeper material that matches the app.

| Checklist | Open when | Do not assume |
| --- | --- | --- |
| `launch-gates.md` | Mapping the selected sharing stage to review domains | Every later-stage item is a current blocker |
| `production-readiness.md` | Any app is moving beyond localhost; inspect sections matching components that exist | Every app needs a cache, queue, gateway, container, search engine, or microservice |
| `auth-security.md` | The app has accounts, private data, admin actions, APIs, uploads, or server-side URL fetching | Login alone proves authorization; hiding UI controls protects data |
| `ai-app-readiness.md` | Runtime code calls a model, agent, retriever, or AI tool | An `AGENTS.md` instruction file means the product contains AI |
| `payment-readiness.md` | Test or real money, subscriptions, credits, invoices, wallets, or payment webhooks exist | Every payment method uses the card ecosystem or the same state model |
| `customer-and-business-operations.md` | Real users, personal data, transactional messages, payments, support promises, or trust claims exist | Generic legal, tax, retention, or provider timelines apply everywhere |
| `multi-tenant-enterprise.md` | Organizations, teams, workspaces, tenants, enterprise identity, or support impersonation exist | Enterprise controls are required for a single-user local prototype |

Within a focused checklist, phrases such as “if used,” “where applicable,” and feature-specific headings are applicability conditions. Missing evidence is reported as unverified risk; it is not proof that a feature is broken or absent.

The short stage checklist is authoritative for what a beginner must address now. Advanced checklist findings receive blocker/high severity only when the selected stage and actual feature exposure make them required.
