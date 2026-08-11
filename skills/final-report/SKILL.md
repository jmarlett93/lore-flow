---
name: final-report
description: Produces the concise, evidence-backed Universal Flow completion report across PR sequencing, requirement coverage, builds, checks, reviews, risks, and artifacts. Use at the end of a run or when handing off a blocked run.
---

# Final Report

Summarize the run from indexed artifacts. Do not reconstruct events from transcripts or
claim success from agent confidence.

## Inputs

- run manifest and artifact index
- accepted PRD review and technical requirements
- PR sequence and build packets
- build reports and post-build Ponytail reviews
- mandatory human review records and any realignment artifacts
- decision log
- indexed architecture draft versions and durable documentation assignments
- indexed diagram coverage and build validation evidence

Validate that referenced artifacts exist, their versions match mandatory approvals, and
their statuses agree. A missing, conflicting, stale, invalidated, or superseded input is
an explicit report finding and cannot support `completed`.
Apply the orchestrator human-readable output policy to the report and all narration.

## Determine outcome

Use one outcome:

- `completed`: every in-scope requirement has build evidence, required checks, an
  accepted post-build review, and every assigned durable doc/ADR update is verified
- `partially-completed`: useful PRs are ready but one or more requirements are blocked
- `blocked`: implementation cannot proceed or no PR is ready
- `failed`: required execution or verification failed without a safe handoff

Do not convert `not-run`, `unknown`, or missing evidence into a pass. Distinguish code
readiness from merge, deployment, or production validation.

## Reconcile

Before writing:

1. Map every frontier item to named requirements.
2. Map every requirement to its owning PR and outcome.
3. Confirm dependency and recommended merge order.
4. Summarize tests and checks by PR, including failures and omissions.
5. Confirm each post-build Ponytail outcome.
6. For infrastructure, report local and hosted configuration separately.
7. Collect decisions, deviations, residual risks, and intentionally deferred work.
8. Confirm requirements and sequence approvals identify the versions that were built.
9. Summarize realignments, aliases, supersession, and preserved unaffected work.
10. Confirm every planned durable architecture doc/ADR was assigned once, updated by its
    owning PR, and verified; distinguish it from run-only draft evidence.
11. Confirm each required diagram's purpose, type, home, source requirements, delivery,
    and syntax/rendering evidence. Report justified no-diagram decisions.
12. Identify the smallest next action for every blocker.

## Output contract

Write `reports/<feature-slug>-final.md`:

```markdown
# Universal Flow Final Report
Display name:
Plain-language purpose:
Internal ID:
Outcome: completed | partially-completed | blocked | failed

## Executive summary
## Deliverables and PR order
## Frontier and requirement coverage
## Checks and review evidence
## Configuration and rollout
## Architecture documentation coverage
### Diagram coverage and validation
## Decisions and deviations
## Open questions
## Risks, blockers, and next actions
## Deferred and out-of-scope work
## Artifact index
```

For each PR report:

- PR ID, title, area, worktree/branch or diff reference
- requirement IDs and dependency
- build outcome and post-build review outcome
- checks: passed, failed, and not run
- merge or handoff readiness

Use links or paths to detailed artifacts instead of copying their contents. Keep the
executive summary to ten bullets or fewer.

## Return

Return the overall outcome, ordered PR list, critical evidence, unresolved blockers, and
the readable final-report path. State whether commits, pushes, PR creation, merges,
deployment, and hosted validation occurred; never imply external actions without
evidence.
