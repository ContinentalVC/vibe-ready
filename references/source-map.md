# Source Map

Vibe Ready is practical guidance, not a certification. This map explains where major ideas came from and how they are used. It does not imply endorsement by the authors or publishers.

Sources should be reviewed periodically because standards, provider behavior, and recommended controls change.

| Source | Ideas used in Vibe Ready | Where applied |
| --- | --- | --- |
| [Google SRE launch checklist](https://sre.google/sre-book/launch-checklist/) and [Reliable Product Launches](https://sre.google/sre-book/reliable-product-launches/) | Capacity estimates, dependency failures, rollback, monitoring, concrete and curated launch checks | `launch-gates.md`, `production-readiness.md`, launch and resilience templates |
| [OWASP Top 10](https://owasp.org/www-project-top-ten/) and [OWASP ASVS](https://owasp.org/www-project-application-security-verification-standard/) | Web threats, authorization, input/output controls, session and verification scope | `auth-security.md`, `production-readiness.md` |
| [OWASP Top 10 for LLM Applications](https://genai.owasp.org/llm-top-10/) | Prompt injection, improper output handling, excessive agency, unbounded consumption | `ai-app-readiness.md` |
| [The Twelve-Factor App](https://12factor.net/) | Configuration, dependencies, build/release/run separation, disposability, logs | `production-readiness.md` |
| [Designing Data-Intensive Applications](https://www.oreilly.com/library/view/designing-data-intensive-applications/9781098119058/) | Explicit data-system trade-offs, systems of record and derived data, consistency, replication, partitioning, streams | database, cache, async-event, and architecture-decision checks |
| [System Design Interview, Volumes 1 and 2](https://blog.bytebytego.com/p/system-design-interview-books-volume) | Beginner-friendly estimation and bottleneck prompts | capacity questions only; this interview-prep series is not treated as a production standard |
| [Software Architecture: The Hard Parts](https://www.oreilly.com/library/view/software-architecture-the/9781492086888/) | Architecture decision records, fitness functions, service granularity, distributed workflow and transaction trade-offs | architecture-decision template and workload-based component guidance |
| [Release It!, Second Edition](https://www.pragmatic.org/titles/mnee2/release-it-second-edition/) | Stability antipatterns, circuit breakers, failure containment, production behavior | dependency-resilience plan and capacity/resilience checklist |
| [Building Microservices, Second Edition](https://www.oreilly.com/library/view/building-microservices-2nd/9781492034018/) | Independent deployment, service boundaries, contracts, testing, monitoring, user-to-service and service-to-service security | API, async-event, service-auth, and architecture trade-off checks |
| [Accelerate](https://itrevolution.com/product/accelerate/) and [DORA delivery metrics](https://dora.dev/guides/dora-metrics/) | Measuring delivery speed and stability to guide improvement | delivery-health template |
| [The DevOps Handbook](https://itrevolution.com/the-devops-handbook/) | Flow, feedback, continual learning, deployment and operational collaboration | CI/CD, postmortem, and delivery feedback guidance |

## Maintenance

- Owner:
- Last full source review:
- Next review:
- Changed provider or standards behavior to incorporate:

When a checklist item makes a legal, tax, insurance, privacy, compliance, payment-provider, email-provider, or cloud-provider claim, link the current primary source directly and record the product-specific basis.
