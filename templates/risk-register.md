# Risk Register

| Risk | Severity | Evidence | Owner | Decision | Due Date |
| --- | --- | --- | --- | --- | --- |
| Example: Missing webhook signature verification | Blocker | `api/webhooks/stripe.ts` |  | Fix before launch |  |
| Example: Missing dependency lockfile | High | `package.json` exists without `package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`, or `bun.lockb` |  | Fix before public beta |  |
| Example: Cache invalidation not defined for entitlements | High | `lib/cache.ts` caches plan status for 30 minutes |  | Fix before launch |  |
| Example: User uploads stored in database blobs | Medium | `uploads` table stores raw image bytes |  | Accept temporarily |  |

## Decision Values

- Fix before launch
- Fix before public beta
- Accept temporarily
- Defer
- Not applicable
