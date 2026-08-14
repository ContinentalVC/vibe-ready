# Production Readiness Checklist

Reference anchor: aligned with practical launch-readiness guidance from OWASP Top 10 2021, OWASP ASVS-style controls, 12-Factor config discipline, cloud well-architected security/reliability guidance, and Google SRE production-readiness practices.

Use this before calling an app production-ready.

## Launch Blockers

- [ ] Secure authentication exists for protected areas.
- [ ] Authorization is enforced server-side.
- [ ] Secrets are stored server-side or in a secrets manager.
- [ ] No production secrets are committed.
- [ ] Database schema changes use migrations.
- [ ] Production, staging, and development data are separated.
- [ ] Backups exist and restore has been tested.
- [ ] Rollback steps are documented and tested.
- [ ] User-facing errors do not expose stack traces or secrets.
- [ ] Basic monitoring exists for uptime, errors, and latency.
- [ ] Critical third-party failures have defined fallback behavior.

## Deployment

- [ ] Deploys are not made directly from local machines to production.
- [ ] Preview or staging deploys exist.
- [ ] Risky features can be disabled or rolled back.
- [ ] Risky releases roll out in stages such as internal, beta, canary, percentage rollout, then full rollout.
- [ ] The deployment strategy—canary, blue-green, rolling, recreate, shadow, or another pattern—is chosen intentionally; traffic-shift steps, health gates, schema compatibility, feature-flag state, and automatic/manual rollback triggers are documented.
- [ ] Operators can roll back first and diagnose after when user impact is active.
- [ ] Recovery and rollback have been exercised, not just documented.
- [ ] Environment variables are documented.
- [ ] CI runs tests, lint, dependency audit, and secret scanning.
- [ ] CI/CD is fast and reliable enough that teams do not avoid deploys because the pipeline is painful.
- [ ] Post-deploy monitoring is part of the release process.
- [ ] 12-Factor App principles are followed where applicable: single codebase, declared dependencies, config in environment, backing services as attached resources, build/release/run separation, stateless processes, port binding, concurrency via process model, disposability (fast startup, graceful shutdown), dev/prod parity, log streaming, and admin processes run separately.
- [ ] API testing covers multiple types: smoke, functional, integration, regression, load, stress, security, and fuzz testing—at minimum smoke, functional, and security for launch.

## Dependencies And Supply Chain

- [ ] Dependency manifests and lockfiles are committed where the ecosystem supports lockfiles.
- [ ] Production installs are deterministic and do not float to unreviewed package versions.
- [ ] Direct and transitive dependencies are scanned for known vulnerabilities before release.
- [ ] Dependency update automation is reviewed rather than blindly merged.
- [ ] Unused dependencies are removed, especially packages with broad postinstall, filesystem, network, or environment access.
- [ ] New dependencies have a reason that justifies their maintenance and security surface area.

## Backend And API

- [ ] Business logic lives server-side.
- [ ] Input validation exists at API boundaries.
- [ ] API validation distinguishes structural checks (types, required fields, formats, content type), semantic checks (business invariants and cross-field rules), canonicalization, and authorization. Request-body, field-count, nesting, and pagination limits prevent oversized or pathological payloads.
- [ ] Validation errors are stable, safe, and field-specific enough for clients to recover without exposing internals. "Sanitization" is not used as a substitute for parameterized queries or context-aware output encoding.
- [ ] Rate limits exist for public or expensive endpoints.
- [ ] Slow tasks use background jobs where needed.
- [ ] External API calls are wrapped in service modules.
- [ ] API errors return safe, predictable responses.
- [ ] Response schemas expose only fields the client or integration needs; internal IDs, relationship data, secrets, and sensitive attributes are excluded by default.
- [ ] Object identifiers do not make bulk enumeration easy. Opaque IDs reduce exposure but never replace server-side ownership and authorization checks.
- [ ] Public or partner APIs have an explicit versioning, compatibility, and deprecation policy before consumers depend on them.
- [ ] An API inventory identifies every public, partner, internal, legacy, and shadow endpoint, its owner, version, consumers, data classification, authentication/authorization policy, rate limit, and retirement state.
- [ ] API contracts are machine-readable where practical and validated against implementation in CI.
- [ ] API pagination is implemented for endpoints that return lists or large datasets. Prefer cursor-based or keyset-based pagination over offset-based for large collections to avoid scanning skipped rows.
- [ ] API requests include replay-attack protections where applicable: timestamps, nonces, or short-lived request signatures.
- [ ] External API calls and message processing use retry strategies with backoff (prefer exponential backoff with jitter over linear to avoid retry storms) and maximum retry limits.
- [ ] Expensive or long-running API operations return an asynchronous acknowledgment (HTTP 202) and process in the background, rather than blocking the client.
- [ ] gRPC or binary protocol services, if used, have defined timeouts, message size limits, and error handling distinct from REST endpoints.
- [ ] REST, GraphQL, gRPC, WebSocket, polling, and event-stream choices are based on request shape, streaming needs, compatibility, cache behavior, failure semantics, and measured load—not fixed protocol-speed assumptions.
- [ ] If an API gateway or backend-for-frontend is used, routing, authentication, authorization, rate limiting, request/response transformation, aggregation, timeout, and observability behavior are explicit. Downstream services do not trust the gateway as their only authorization control.

## Database

- [ ] Migrations are version-controlled.
- [ ] Production migrations are backward-compatible where possible.
- [ ] Destructive schema changes use an expand-contract plan and are not bundled with dependent application changes in the same deploy.
- [ ] Rollback or forward-fix behavior is defined for failed migrations.
- [ ] Indexes exist for common queries.
- [ ] Slow queries can be inspected.
- [ ] Critical queries have measured latency/cardinality budgets, representative execution plans, and regression checks where practical; indexes are verified against real plans rather than added by intuition alone.
- [ ] Connection pooling is configured where needed.
- [ ] Duplicate or inconsistent records are handled.
- [ ] Database scaling strategy is documented: indexing, materialized views, denormalization, vertical scaling, caching, read replication, or sharding—chosen based on the actual bottleneck (reads vs. writes vs. query complexity).
- [ ] Table partitioning or sharding, if used, defines the partition key, hot-partition risk, cross-partition query behavior, rebalancing, backup/restore, uniqueness, and migration strategy.
- [ ] Database locks and potential deadlocks are considered in concurrent write paths. Lock timeouts or deadlock detection exists where applicable.
- [ ] Data management patterns are intentional: cache-aside, CQRS, event sourcing, or sharding—each with documented tradeoffs for the use case.
- [ ] A database-platform migration is triggered by measured capacity, cost, or missing capability—not frustration alone—and has milestones, rollback points, data verification, and an owner.
- [ ] Large data moves or engine changes define dual-write/read behavior, backfill verification, cutover criteria, and reconciliation where applicable.

## Async Events And Data Synchronization

- [ ] The source of truth is documented for every search index, analytics store, cache, notification system, and other downstream projection.
- [ ] Change propagation uses an intentional pattern such as a transactional outbox, change data capture, or application events; database commits and event publication cannot silently diverge.
- [ ] Event consumers are idempotent and deduplicate retries.
- [ ] Ordering requirements are explicit: global, per tenant/account/entity, per conversation/stream, or unordered. Partition keys, sequence/version checks, stale-event handling, and user-visible conflict behavior match that scope.
- [ ] Event schemas are versioned, and consumers receive only the event types and fields they need.
- [ ] Retries are bounded and failed messages enter a dead-letter or equivalent recovery path with alerting, ownership, and replay tooling.
- [ ] Reconciliation can detect and repair missed, duplicated, delayed, or out-of-order updates across dependent systems.
- [ ] Event lag, delivery failures, dead-letter depth, and replay outcomes are observable.

## Data Protection

- [ ] TLS/HTTPS is enforced for all production traffic.
- [ ] HTTP redirects to HTTPS.
- [ ] Sensitive data is encrypted at rest in databases, backups, and object storage where applicable.
- [ ] Sensitive logs, exports, and attachments have retention and access controls.
- [ ] Encoding, encryption, and tokenization are used appropriately for their distinct purposes: encoding (Base64) for data format transmission, encryption (symmetric/asymmetric) for confidentiality, and tokenization (with a token vault) for replacing sensitive data like payment card numbers with non-reversible placeholders.
- [ ] Sensitive data management includes data desensitization or anonymization for external data sharing, minimal data permissions via RBAC, and data lifecycle management (permissions granted during development are revoked when data goes live).
- [ ] Encryption keys use a split-key or multi-role model (e.g., key holder, key manager, auditor) where key exposure would be catastrophic.

## Files And Object Storage

- [ ] User-uploaded files, images, videos, and PDFs are stored in object storage, not as large database blobs, unless there is a documented reason.
- [ ] Databases store file metadata, ownership, and object references rather than raw large file contents where practical.
- [ ] File buckets default to private for sensitive or user-owned content.
- [ ] File access uses signed URLs, permission checks, or scoped public paths intentionally.
- [ ] Public assets are served through a CDN or equivalent cache layer where expected traffic justifies it.
- [ ] File retention, deletion, and orphan cleanup behavior are defined.

## Observability

- [ ] Structured logs include timestamp, request ID, and relevant entity IDs.
- [ ] Logs avoid secrets and sensitive payloads.
- [ ] Errors are searchable.
- [ ] Logs are structured enough to filter by user, tenant, request, job, deployment, and external dependency where applicable.
- [ ] Alerts exist for downtime and elevated error rates.
- [ ] Alerts are actionable and route to a page, ticket, or log-only destination intentionally.
- [ ] An SLO or user-facing reliability target is defined for critical workflows.
- [ ] Error-budget burn or equivalent reliability drift is visible before users report it.
- [ ] Queue depth, database performance, and background failures are visible where applicable.
- [ ] Critical user journeys are monitored at the business outcome level, not only by host health or HTTP status—for example completed checkout, account recovery, entitlement update, or message delivery.
- [ ] Repeated support reports are classified by root cause and can create an observability, UX, or business-logic follow-up instead of remaining isolated tickets.
- [ ] The components the app actually uses are inventoried, owned, and instrumented. Hosting/runtime, DNS, data stores, external dependencies, and observability match the deployed system; load balancers, CDNs, gateways, caches, search, queues, workers, containers, and additional services are required only when the workload or platform needs them.
- [ ] End-to-end latency budgets are allocated across DNS, connection/TLS setup, CDN/gateway, service fan-out, cache/database, queues, and external dependencies where applicable. Warm/cold, cached/uncached, regional/cross-region, and tail latency are measured for this system rather than inferred from universal reference numbers.

## Caching And Consistency

- [ ] Cache invalidation is explicit for user-visible data changes.
- [ ] Cache TTLs are documented and are not the only consistency strategy for critical data.
- [ ] Cache stampede behavior is handled with locking, request coalescing, stale-while-revalidate, or equivalent controls where needed.
- [ ] CDN, application, Redis, browser, and database cache layers have a documented source of truth and invalidation order.
- [ ] Cached authorization, entitlement, pricing, inventory, or profile data cannot remain stale long enough to create a security, billing, or support issue.
- [ ] Cache failure modes are addressed: thunder herd (randomized TTLs, circuit breakers for non-core data), cache penetration (null-value caching, bloom filters), cache breakdown (no TTL on hot keys), and cache crash (circuit breakers, clustering for availability).
- [ ] Cache eviction strategy is chosen intentionally for the use case (LRU, LFU, TTL, FIFO, two-tiered) and documented.
- [ ] Sensitive user data deletion is verified across all cache layers (browser cache, CDN, application cache, distributed cache, database buffer pool, full-text search index, materialized views).

## Capacity And Resilience

- [ ] Expected launch traffic and credible spike traffic are estimated.
- [ ] A capacity model records steady and peak requests, concurrency, payload sizes, fan-out, queue arrival/service rates, connection counts, storage growth, bandwidth, regional distribution, and safety headroom for critical paths.
- [ ] Load testing or realistic stress testing has identified the first bottleneck.
- [ ] Overload behavior is intentional: admission control, load shedding, degraded modes, queue caps, concurrency limits, and dependency timeouts preserve the most important user journeys.
- [ ] Resource limits, autoscaling, queue limits, or backpressure behavior are defined where applicable.
- [ ] Failure drills or recovery exercises prove the system can recover from common dependency, deploy, or infrastructure failures.
- [ ] Cloud spend is monitored by service, environment, and owner where the platform supports it.
- [ ] Budget alerts or anomaly alerts exist for usage spikes, runaway jobs, storage growth, AI costs, and bandwidth.
- [ ] Disaster recovery strategy is defined with concrete RTO (Recovery Time Objective) and RPO (Recovery Point Objective). Strategy is one of: backup and restore, pilot light, warm standby, or hot site/multi-site—chosen based on acceptable downtime and data loss.
- [ ] Scaling strategy is documented: stateless services, horizontal scaling, load balancing, auto-scaling, caching, database replication, database sharding, and async processing—applied based on the actual bottleneck.
- [ ] High-availability design is intentional: active-active (with deduplication), active-passive, single-leader cluster, or leaderless cluster—chosen based on consistency and uptime requirements.
- [ ] Cloud cost efficiency is reviewed: rightsized instances, idle resource termination, scheduled shutdowns during off-peak, reserved instances or savings plans, data transfer optimization (CDN, compression), and spot instances for fault-tolerant workloads.
- [ ] Serverless, containers, and dedicated compute are selected per workload using measured unit cost, scaling behavior, latency, operational ownership, and failure modes; no platform migration is justified by fashion alone.
- [ ] Critical dependencies have an explicit total deadline, per-attempt timeout, bounded retry count, backoff/jitter policy where appropriate, and a retry budget that prevents retries multiplying across service layers.
- [ ] Failure isolation is intentional: optional or failing dependencies cannot exhaust every worker, connection, thread, concurrency slot, or queue slot needed by critical paths.
- [ ] Health checks, startup, graceful shutdown, and deploy interruption behavior preserve acknowledged work and do not restart healthy processes solely because an optional dependency is unavailable.
- [ ] Material infrastructure or service additions are justified by measured workload evidence and recorded in an architecture decision; keeping the current simpler design is always considered.

## Documentation And Operations

- [ ] Setup, deploy, rollback, and common support workflows are documented for someone other than the original builder.
- [ ] Operational docs identify owners for auth, database, storage, billing, AI providers, monitoring, and incident response.
- [ ] Known tradeoffs and accepted risks are recorded in a risk register with an owner and review date.
- [ ] Material architecture decisions record the need, workload evidence, simpler options considered, chosen trade-off, rollback path, and measurable checks that keep the decision true.
- [ ] Important external and internal dependencies have timeout, retry, isolation, degraded-mode, recovery, and ownership details recorded in a dependency-resilience plan.

## Delivery Feedback

- [ ] Production teams define and observe change lead time, deployment frequency, change failure rate, failed-deployment recovery time, and deployment rework using definitions appropriate to this product.
- [ ] Delivery measurements are used to find friction and improve the same product over time, not to rank unrelated teams or reward raw deployment counts.
- [ ] A small, reversible improvement experiment has an owner, expected outcome, and review date.

## Verification Strategy

- [ ] Tests are created with the feature or defect fix, not deferred indefinitely until after launch.
- [ ] Unit, integration, contract, and end-to-end tests have distinct scopes and run at a cadence that keeps CI useful.
- [ ] Coverage thresholds, if used, are risk-based and cannot substitute for assertions on critical workflows and unhappy paths.
- [ ] Critical workflows cover invalid input, retries, duplicate submissions, timeouts, partial third-party failure, permissions, and recovery.
- [ ] Browser and device coverage reflects actual users, including supported mobile layouts and browsers.
- [ ] Release gates fail when required tests fail; bypasses require a named approver and recorded reason.

## Frontend

- [ ] Loading, empty, error, and success states exist.
- [ ] Forms handle invalid, empty, duplicate, and large inputs.
- [ ] Double-clicks and rapid submissions do not duplicate critical actions.
- [ ] App has been checked on mobile and desktop.
- [ ] Critical flows such as signup, account recovery, checkout, file upload, and deletion have been exercised on each supported device/browser class.
- [ ] Product can be understood without a live demo.
- [ ] Frontend performance is measured: Time to First Byte (TTFB), First Contentful Paint (FCP), DOMContentLoaded time, total page size, request count, and round-trip time (RTT). Budgets exist for critical paths.
- [ ] Render-blocking resources are minimized and above-the-fold content loads first.
- [ ] Bundle size is controlled: code splitting, tree shaking or dead code removal, compression, dynamic imports for non-critical modules, and preloading/prefetching of likely-needed resources.
