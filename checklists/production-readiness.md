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
- [ ] Rate limits exist for public or expensive endpoints.
- [ ] Slow tasks use background jobs where needed.
- [ ] External API calls are wrapped in service modules.
- [ ] API errors return safe, predictable responses.
- [ ] API pagination is implemented for endpoints that return lists or large datasets. Prefer cursor-based or keyset-based pagination over offset-based for large collections to avoid scanning skipped rows.
- [ ] API requests include replay-attack protections where applicable: timestamps, nonces, or short-lived request signatures.
- [ ] External API calls and message processing use retry strategies with backoff (prefer exponential backoff with jitter over linear to avoid retry storms) and maximum retry limits.
- [ ] Expensive or long-running API operations return an asynchronous acknowledgment (HTTP 202) and process in the background, rather than blocking the client.
- [ ] gRPC or binary protocol services, if used, have defined timeouts, message size limits, and error handling distinct from REST endpoints.

## Database

- [ ] Migrations are version-controlled.
- [ ] Production migrations are backward-compatible where possible.
- [ ] Destructive schema changes use an expand-contract plan and are not bundled with dependent application changes in the same deploy.
- [ ] Rollback or forward-fix behavior is defined for failed migrations.
- [ ] Indexes exist for common queries.
- [ ] Slow queries can be inspected.
- [ ] Connection pooling is configured where needed.
- [ ] Duplicate or inconsistent records are handled.
- [ ] Database scaling strategy is documented: indexing, materialized views, denormalization, vertical scaling, caching, read replication, or sharding—chosen based on the actual bottleneck (reads vs. writes vs. query complexity).
- [ ] Database locks and potential deadlocks are considered in concurrent write paths. Lock timeouts or deadlock detection exists where applicable.
- [ ] Data management patterns are intentional: cache-aside, CQRS, event sourcing, or sharding—each with documented tradeoffs for the use case.

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
- [ ] Core production components are present and instrumented: CI/CD pipeline, DNS, load balancer/reverse proxy, CDN, API gateway, backend services, database, distributed cache, full-text search, job queue/workers, log aggregation, and alerting.
- [ ] Key latency numbers for the system are known and monitored (e.g., cache read ~100ns, disk read ~100μs, database commit ~1ms, cross-region ~100ms). Budget alerts exist when latency approaches revenue-impacting thresholds.

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
- [ ] Load testing or realistic stress testing has identified the first bottleneck.
- [ ] Resource limits, autoscaling, queue limits, or backpressure behavior are defined where applicable.
- [ ] Failure drills or recovery exercises prove the system can recover from common dependency, deploy, or infrastructure failures.
- [ ] Cloud spend is monitored by service, environment, and owner where the platform supports it.
- [ ] Budget alerts or anomaly alerts exist for usage spikes, runaway jobs, storage growth, AI costs, and bandwidth.
- [ ] Disaster recovery strategy is defined with concrete RTO (Recovery Time Objective) and RPO (Recovery Point Objective). Strategy is one of: backup and restore, pilot light, warm standby, or hot site/multi-site—chosen based on acceptable downtime and data loss.
- [ ] Scaling strategy is documented: stateless services, horizontal scaling, load balancing, auto-scaling, caching, database replication, database sharding, and async processing—applied based on the actual bottleneck.
- [ ] High-availability design is intentional: active-active (with deduplication), active-passive, single-leader cluster, or leaderless cluster—chosen based on consistency and uptime requirements.
- [ ] Cloud cost efficiency is reviewed: rightsized instances, idle resource termination, scheduled shutdowns during off-peak, reserved instances or savings plans, data transfer optimization (CDN, compression), and spot instances for fault-tolerant workloads.

## Documentation And Operations

- [ ] Setup, deploy, rollback, and common support workflows are documented for someone other than the original builder.
- [ ] Operational docs identify owners for auth, database, storage, billing, AI providers, monitoring, and incident response.
- [ ] Known tradeoffs and accepted risks are recorded in a risk register with an owner and review date.

## Frontend

- [ ] Loading, empty, error, and success states exist.
- [ ] Forms handle invalid, empty, duplicate, and large inputs.
- [ ] Double-clicks and rapid submissions do not duplicate critical actions.
- [ ] App has been checked on mobile and desktop.
- [ ] Product can be understood without a live demo.
- [ ] Frontend performance is measured: Time to First Byte (TTFB), First Contentful Paint (FCP), DOMContentLoaded time, total page size, request count, and round-trip time (RTT). Budgets exist for critical paths.
- [ ] Render-blocking resources are minimized and above-the-fold content loads first.
- [ ] Bundle size is controlled: code splitting, tree shaking or dead code removal, compression, dynamic imports for non-critical modules, and preloading/prefetching of likely-needed resources.
