# AI App Readiness Checklist

Use this for apps that call LLMs, image/video models, transcription models, agents, MCP tools, or AI workflow APIs.

## Output Safety

- [ ] Structured model outputs are schema-validated.
- [ ] Invalid model output has retry or fallback behavior.
- [ ] Raw model output is not piped directly into critical workflows.
- [ ] User-visible AI output has appropriate review or disclaimers for the domain.
- [ ] Prompts and model versions are tracked.

## Cost Controls

- [ ] AI endpoints require auth where appropriate.
- [ ] Per-user, per-team, or per-plan usage limits exist.
- [ ] Provider spend caps or alerts are configured.
- [ ] Expensive endpoints have rate limits.
- [ ] Repeated prompts or expensive context are cached where practical.
- [ ] Smaller/cheaper models are used for simple classification, extraction, formatting, and summaries.

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
- [ ] Tool failures are handled clearly.
- [ ] Agent actions are logged.
- [ ] Memory stores respect source permissions.

## Evaluation

- [ ] Real failure cases are collected.
- [ ] Prompt/model changes are compared against test cases or evals.
- [ ] Quality, safety, schema compliance, latency, and cost are measured before rollout.
- [ ] Autonomous behavior is tested internally before customer exposure.
