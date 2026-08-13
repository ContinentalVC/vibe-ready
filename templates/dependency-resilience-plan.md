# Dependency Resilience Plan

Use this for every external API, database, queue, cache, model provider, payment processor, email provider, or internal service on an important user journey.

| Dependency | User journey | Timeout / deadline | Retry limit and backoff | Isolation / concurrency limit | Circuit open or degraded behavior | Recovery owner |
| --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |

## Rules Of Thumb To Verify

- [ ] One user request cannot retry indefinitely or for longer than its total deadline.
- [ ] Retries are limited, use backoff with jitter where appropriate, and do not multiply across every service layer.
- [ ] Slow or failing optional dependencies cannot consume every worker, connection, thread, or queue slot.
- [ ] Health checks test whether the process can safely receive traffic; they do not restart healthy processes merely because an optional dependency is down.
- [ ] Startup, shutdown, and deploy interruption do not lose acknowledged work.
- [ ] The degraded experience preserves the most important user journey and clearly tells the user what happened.
- [ ] Recovery from an outage, backlog, open circuit, or failed retry has been tested.
