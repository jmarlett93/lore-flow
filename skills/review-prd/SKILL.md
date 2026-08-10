---
name: review-prd
description: Reviews a product requirements document to define the current-to-requested behavior frontier, expose ambiguity, and produce evidence-backed build gates. Use before technical discovery or implementation planning.
---

# Review PRD

Define what the product does now, what the PRD asks it to do, and the exact frontier
between them. Review product intent; do not design the implementation.

## Inputs

- PRD path or authoritative source
- target repository path
- run artifact root
- known decisions and constraints

Inspect repository evidence only as needed to verify claims about current behavior.
Label unsupported claims rather than filling gaps from intuition.

## Review

1. Extract actors, triggers, outcomes, acceptance criteria, exclusions, and rollout needs.
2. Record current behavior with repository or product evidence.
3. Record requested behavior with citations to the PRD.
4. Define frontier items: the smallest observable differences between current and
   requested behavior.
5. Find contradictions, ambiguous terms, missing edge cases, and unowned decisions.
6. Separate product requirements from suggested implementation.
7. Decide whether technical discovery may proceed.

Challenge:

- implied actors, permissions, data ownership, and error behavior
- unclear source of truth or lifecycle
- missing empty, loading, failure, retry, and concurrency behavior
- unstated compatibility, migration, telemetry, or rollout expectations
- acceptance criteria that cannot be observed or tested
- requirements that conflict with explicit non-goals

## Output contract

Write `prd-review.md` under the run root:

```markdown
# PRD Review
Status: accepted | clarification-required | blocked

## Executive summary
## Sources and evidence
## Current behavior
## Requested behavior
## Frontier
- F-001: [actor] changes from [current] to [requested]
  - Evidence:
  - Acceptance observation:
## In scope
## Out of scope
## Ambiguities and contradictions
## Product decisions required
## Discovery questions
## Gate
```

Every frontier item must be independently observable and cite both sides when current
behavior exists. Use `unknown` when evidence is absent.

## Gate rules

Return `accepted` only when:

- each requested behavior maps to a frontier item or explicit non-goal
- acceptance is observable
- no critical contradiction remains
- open questions can be resolved technically without changing product intent

Return `clarification-required` when a product choice materially changes behavior,
scope, security, persistence, or user experience. Ask the smallest answerable questions.
Return `blocked` when the source is unavailable or internally irreconcilable.

Return to the orchestrator only a short status, frontier summary, decision requests, and
artifact path. Do not forward source text or a transcript.
