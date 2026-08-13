# Architecture Decision Record

Use this for a choice that would be expensive, risky, or confusing to reverse. Examples: adding a service, database, cache, queue, search engine, AI provider, auth system, or public API.

## Decision

- Title:
- Owner:
- Date:
- Status: proposed / accepted / replaced / retired
- Review date or trigger:

## The Need

- What user or operational problem are we solving?
- What evidence shows the problem exists now?
- What happens if we keep the current design?

## Real Workload

- Expected and peak requests or jobs:
- Data size and growth:
- Required response time:
- Acceptable downtime and data loss:
- Security, privacy, tenant, or cost constraints:

## Options Considered

| Option | Benefits | Costs / failure modes | Evidence | Why accepted or rejected |
| --- | --- | --- | --- | --- |
| Keep the current/simple design |  |  |  |  |
|  |  |  |  |  |

## Chosen Trade-Off

- Decision:
- Why this is the simplest option that meets the need:
- What becomes harder because of this choice:
- Migration and rollback plan:

## Checks That Keep The Decision True

List measurable architecture checks that can run in CI or monitoring—for example, “frontend bundles contain no server secrets,” “p95 checkout latency stays below the agreed budget,” or “services do not read another service's database directly.”

| Check | Where it runs | Failure owner |
| --- | --- | --- |
|  |  |  |
