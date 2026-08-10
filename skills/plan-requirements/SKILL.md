---
name: plan-requirements
description: Converts an accepted PRD frontier and stack discovery into named, testable technical requirements for model, contract, state, and behavior changes. Use before PR sequencing and implementation.
---

# Plan Requirements

Produce the technical contract for implementation. Requirements describe necessary
changes and acceptance, not line-by-line code.

## Inputs

- accepted `prd-review.md`
- `discovery-index.md` and all three area reports
- decisions, constraints, and explicit non-goals
- output path under the run root

Do not rely on conversations or transcripts. If an input is missing or contradictory,
return `blocked` with the exact artifact or decision needed.

## Requirement taxonomy

Every change must be a named requirement of one of these types:

- `MODEL`: domain or persisted data shape, invariant, lifecycle, or migration
- `CONTRACT`: API, event, command, schema, integration, or cross-area boundary
- `STATE`: client/server state, transition, synchronization, caching, or failure state
- `BEHAVIOR`: observable user, system, operational, or accessibility behavior

Use IDs such as `MODEL-user-preference`, not anonymous bullets. A requirement may depend
on another type but must have one primary type and one owning area.

## Process

1. Map every PRD frontier item to one or more named requirements.
2. Reuse discovered conventions and contracts where they satisfy the frontier.
3. Define inputs, outputs, invariants, failures, and compatibility where relevant.
4. Assign exactly one owner: `frontend`, `backend`, or `infrastructure`.
5. Record dependencies between requirement IDs.
6. Define objective acceptance checks and evidence expected from builds.
7. Mark rollout, migration, local configuration, and hosted configuration duties.
8. For each requirement, record architecture impact (`none`, `update`, or `decision`) and
   exact durable architecture/ADR updates using discovered repository conventions.
9. Verify that each requirement is necessary; leave implementation choices open unless
   the choice is itself required for compatibility or correctness.

Do not hide cross-area work in one requirement. Split it at the contract boundary.

## Architecture drafts

When a change meaningfully alters system boundaries, contracts, data flow, deployment,
or a consequential design decision, create source drafts under the run root at
`architecture/`: `overview.md`, only relevant `frontend.md`, `backend.md`, or
`infrastructure.md`, and `adr/<decision-id>.md` only when a decision warrants an ADR.
Index and version each draft. State its target durable path from discovery, defaulting
to `docs/architecture/` and `docs/adr/` only when no convention exists.

Drafts are run evidence, not committed documentation. Do not create them for trivial
implementation details, formatting, or unchanged architecture. Record `none` explicitly.

## Output contract

Write `requirements.md`:

```markdown
# Technical Requirements
Status: accepted | clarification-required | blocked

## Scope and constraints
## Requirement index
## Requirements
### CONTRACT-create-widget
- Type: CONTRACT
- Owner: backend
- Frontier: F-001
- Purpose:
- Inputs/outputs:
- Invariants and failures:
- Depends on:
- Acceptance checks:
- Evidence:
- Architecture impact: none | update | decision
- Durable docs/ADRs: [exact target paths and action, or none]
- Run drafts: [versioned architecture paths, or none]
- Non-goals:
## Dependency graph
## Cross-area contracts
## Architecture documentation plan
## Migration and rollout
## Local and hosted configuration
## Coverage matrix
## Unknowns and decisions
```

The coverage matrix maps every frontier item to requirement IDs and every requirement to
an acceptance check. No orphan frontier items or requirements are allowed.

## Gate

Accept only if requirements are named, necessary, testable, area-owned, dependency-aware,
evidence-backed, and explicit about architecture documentation. Escalate product choices;
do not resolve them as technical details.
Return status, counts by type and owner, blockers, and the artifact path.
