# Rollback Plan

## Trigger Conditions

- Error rate above:
- Latency above:
- Payment failures:
- Security issue:
- Data integrity issue:
- Stale cache or entitlement issue:
- RAG/index freshness or permission leak:
- AI cost spike:
- Cloud cost spike:

## Rollback Steps

1.
2.
3.

## Data Considerations

- Migrations to revert:
- Data backfill needed:
- Cache purge or revalidation needed:
- Object storage or CDN changes to revert:
- Search/vector index, embedding, retriever, or reranker version to revert:
- Traffic percentage, canary cohort, gateway route, or feature-flag state to restore:
- User-visible impact:

## Owners

- Release owner:
- Engineering owner:
- Support owner:

## Verification

- [ ] Previous version restored
- [ ] Critical path works
- [ ] Logs confirm recovery
- [ ] Traffic and error/latency gates confirm the prior version is healthy
- [ ] Cache/search/vector projections are compatible or rebuilt and permissions reverified
- [ ] Users/support notified if needed
