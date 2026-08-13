# AI App Readiness Checklist

Reference anchor: aligned with OWASP LLM Top 10 v2025 threat categories such as prompt injection, improper output handling, excessive agency, and unbounded consumption.

Use this for apps that call LLMs, image/video models, transcription models, agents, MCP tools, or AI workflow APIs.

## Output Safety

- [ ] Structured model outputs are schema-validated.
- [ ] Invalid model output has retry or fallback behavior.
- [ ] Raw model output is not piped directly into critical workflows.
- [ ] LLM output reaching a database, browser, shell, workflow tool, or API is treated as untrusted input.
- [ ] LLM-derived content uses parameterized queries, context-aware output encoding, and content security policy where applicable.
- [ ] User-visible AI output has appropriate review or disclaimers for the domain.
- [ ] Prompts and model versions are tracked.
- [ ] Input/output moderation and policy enforcement match the product's users, content, domain, and abuse model. When moderation is required, provider failure or timeout has an explicit fail-open or fail-closed decision and does not silently expose content outside the product policy.

## Prompt Injection And Untrusted Context

- [ ] Untrusted external content such as web pages, email, files, RAG documents, transcripts, and tool output is segregated from trusted instructions.
- [ ] System/developer instructions explicitly constrain what the model may do with untrusted content.
- [ ] Prompt-injection and jailbreak cases are included in the eval set and tested adversarially before release.
- [ ] Retrieval, summarization, and tool-use flows assume prompt injection cannot be fully prevented and rely on layered controls.

## Retrieval And RAG

- [ ] Retrieval enforces source permissions at query time and prevents cross-user or cross-tenant results; filtering only after retrieval is not accepted for sensitive content.
- [ ] Answers retain source provenance and, where the product requires factual grounding, expose citations or evidence that can be traced to the retrieved chunks.
- [ ] Ingestion, chunking, embedding, metadata, reranker, and retrieval configurations are versioned. Reindex and rollback behavior is defined when any component changes.
- [ ] Source updates, permission changes, retention rules, and deletions propagate to chunks, embeddings, caches, replicas, and backups according to the data-lifecycle plan.
- [ ] Retrieval quality is evaluated separately from generation quality using representative queries and failure cases, including missing, stale, conflicting, poisoned, or permission-restricted sources.
- [ ] Low-confidence or no-result retrieval has a safe response path and does not encourage the model to fill gaps from unsupported memory.
- [ ] Retrieved documents remain untrusted data: embedded instructions cannot expand tool permissions, override system rules, or cause secret/data exfiltration.

## Cost Controls

- [ ] AI endpoints require auth where appropriate.
- [ ] Per-user, per-team, or per-plan usage limits exist.
- [ ] Provider spend caps or alerts are configured.
- [ ] Expensive endpoints have rate limits.
- [ ] Repeated prompts or expensive context are cached where practical.
- [ ] Model choice is justified by measured quality, safety, latency, and cost for the task; smaller or cheaper models are considered when they meet the requirement.

## Reliability

- [ ] Provider timeout behavior is defined.
- [ ] Provider rate-limit behavior is defined.
- [ ] Backup model/provider or graceful degradation exists for critical paths.
- [ ] Long-running AI tasks use background jobs where needed.
- [ ] Failed AI jobs are visible to operators.
- [ ] Custom or fine-tuned model workflows track dataset/feature lineage, experiment runs, validation results, registry stage, deployment version, rollback target, and production drift where applicable.

## Agent And Tool Safety

- [ ] Agents start with read-only tools by default.
- [ ] Write tools require explicit scope and permission.
- [ ] High-risk actions require human approval.
- [ ] Tool parameters are validated.
- [ ] Tool outputs are treated as untrusted context before being fed back to the model or rendered to users.
- [ ] Tool failures are handled clearly.
- [ ] Agent actions are logged.
- [ ] Memory stores respect source permissions.

## Human Escalation

- [ ] Automated support and agent flows define when to stop, disclose uncertainty, and hand off to a human.
- [ ] Billing disputes, access-control conflicts, security reports, privacy requests, safety issues, and other consequential or contested outcomes cannot be closed solely because an AI found no matching system error.
- [ ] Human reviewers receive the relevant case history, model/tool actions, source evidence, and safe administrative controls needed to resolve the issue.
- [ ] Customers can reach a human through a documented path when automation fails or repeatedly misunderstands the request.
- [ ] Human overrides are authorized, audited, and fed back into playbooks or eval cases without storing unnecessary sensitive content.

## Evaluation

- [ ] Real failure cases are collected.
- [ ] Prompt/model changes are compared against test cases or evals.
- [ ] Quality, safety, schema compliance, latency, and cost are measured before rollout.
- [ ] Autonomous behavior is tested internally before customer exposure.
