# Launch Plan

## Project

- Name:
- Owner:
- Launch date:
- Launch gate: Prototype / Private Beta / Public Beta / Production / Enterprise-Ready

## Scope

- What is launching:
- What is not launching:
- Target users:
- Sensitive data involved:
- Payments involved:
- AI features involved:
- Personal data and retention obligations:
- Transactional messages involved:

## Architecture Choices

- Architecture decision records and links:
- Auth approach and owner:
- Service-to-service auth:
- File/object storage:
- Cache layers and source of truth:
- External dependencies:
- Expected cost drivers:
- Async events, projections, and source of truth:
- External API/versioning commitments:
- API inventory and gateway/BFF boundaries:
- Protocol choices and measured latency budget:
- Capacity assumptions and overload/degraded-mode behavior:
- Critical dependency deadlines, retries, isolation, degraded behavior, and recovery owner:
- RAG sources, permission model, provenance, and index lifecycle:

## Pre-Launch Checklist

- [ ] Production-readiness review completed
- [ ] Blockers resolved
- [ ] Accepted risks documented
- [ ] Dependency audit and secret scan completed
- [ ] Browser security headers and CORS reviewed
- [ ] Upload/storage permissions reviewed
- [ ] Cache invalidation reviewed for critical data
- [ ] Rollback tested
- [ ] Monitoring configured
- [ ] Cloud cost or usage alerts configured
- [ ] Support path defined
- [ ] Session expiry, revocation, and recovery tested
- [ ] Data lifecycle plan completed where personal data is stored
- [ ] Critical transactional messages authenticated and monitored
- [ ] Payment recovery and dispute workflows tested where payments are live
- [ ] Human escalation defined for consequential AI/support decisions
- [ ] API inventory, validation limits, and gateway/downstream authorization reviewed
- [ ] RAG permission, provenance, retrieval, and deletion/freshness tests completed where applicable
- [ ] Material components are justified by workload evidence; simpler options and rollback are recorded in architecture decisions
- [ ] Critical dependencies have a completed resilience plan and tested degraded behavior
- [ ] Production delivery-health definitions and an improvement owner exist
- [ ] Security and customer-facing claims verified against evidence
- [ ] Post-launch owner assigned

## Post-Launch Monitoring

- Metrics to watch:
- Logs/dashboard links:
- Alert recipients:
- First review time:
- Cost dashboard or budget alert:
