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
- [ ] Content moderation is applied to both user input and model output before user exposure. Input moderation filters inappropriate requests; output moderation filters unsafe, biased, or harmful responses. Moderation failures fall back to safe template responses rather than exposing unfiltered content.

## Prompt Injection And Untrusted Context

- [ ] Untrusted external content such as web pages, email, files, RAG documents, transcripts, and tool output is segregated from trusted instructions.
- [ ] System/developer instructions explicitly constrain what the model may do with untrusted content.
- [ ] Prompt-injection and jailbreak cases are included in the eval set and tested adversarially before release.
- [ ] Retrieval, summarization, and tool-use flows assume prompt injection cannot be fully prevented and rely on layered controls.
- [ ] AI features with database access read through a connection or query layer already scoped to the authenticated user's rows. Data boundaries are enforced outside the prompt, never by instructing the model to stay in scope.

## Cost Controls

- [ ] AI endpoints require auth where appropriate.
- [ ] Per-user, per-team, or per-plan usage limits exist.
- [ ] Provider spend caps or alerts are configured.
- [ ] Expensive endpoints have rate limits.
- [ ] Repeated prompts or expensive context are cached where practical.
- [ ] Smaller/cheaper models are used for simple classification, extraction, formatting, and summaries.
- [ ] Token spend is attributed per feature, per endpoint, and per customer, not only as one provider bill.
- [ ] Cost to serve is compared against revenue per user, so unprofitable usage patterns are visible before they scale.

## Reliability

- [ ] Provider timeout behavior is defined.
- [ ] Provider rate-limit behavior is defined.
- [ ] Backup model/provider or graceful degradation exists for critical paths.
- [ ] Long-running AI tasks use background jobs where needed.
- [ ] Failed AI jobs are visible to operators.

## Agent And Tool Safety

- [ ] Agents start with read-only tools by default.
- [ ] Write tools require explicit scope and permission.
- [ ] High-risk actions require human approval.
- [ ] Tool parameters are validated.
- [ ] Tool outputs are treated as untrusted context before being fed back to the model or rendered to users.
- [ ] Tool failures are handled clearly.
- [ ] Agent actions are logged.
- [ ] Agents authenticate with their own scoped, short-lived identity rather than a human user's credentials or a shared platform key, so every action is attributable to a specific agent and run.
- [ ] Tools that fetch URLs, browse, or call webhooks enforce an outbound allowlist and cannot reach internal network ranges or cloud metadata endpoints.
- [ ] Long-running agent tasks keep durable state outside the context window, are broken into short stages, and have a human checkpoint between stages rather than one unbounded run.
- [ ] Memory stores respect source permissions.

## Retrieval And Vector Stores

Use this section when the app embeds documents for retrieval, search, or agent memory.

- [ ] Ownership and permission context is attached to content at embed time, not inferred at query time.
- [ ] Retrieval filters by the requesting user's permissions before results reach the model.
- [ ] Retrieved passages are re-checked against the requesting user's access rights before being cited, summarized, or returned.
- [ ] Vector stores, indexes, and agent memory are scoped per tenant wherever the app serves more than one customer.
- [ ] Content is screened for injected instructions at ingest, not only at query time.

## Evaluation

- [ ] Real failure cases are collected.
- [ ] Prompt/model changes are compared against test cases or evals.
- [ ] Quality, safety, schema compliance, latency, and cost are measured before rollout.
- [ ] Autonomous behavior is tested internally before customer exposure.
- [ ] Security review of AI-generated code is run by a different model, tool, or person than the one that wrote it, and is framed as an attempt to break the code rather than a request for general feedback. A model reviewing its own output shares its own blind spots.

## Disclosure And AI Compliance

Applies where AI output reaches users, or where regulation attaches to automated generation. Confirm current obligations with counsel; this is review scope, not legal advice.

- [ ] AI-generated output is labeled where regulation or user expectation requires it, including provenance metadata or watermarks for generated media.
- [ ] Users are told, and where required consent, before their input is sent to a model provider.
- [ ] Generation events are recorded durably with timestamp, model and version, and triggering context, in a form suitable for later audit rather than as ordinary debug logging.
- [ ] Obligations are evaluated against where users are located, not only where the team is located.
- [ ] Model and provider changes are reviewed against any commitments made about data handling, training use, or retention.
