---
name: discover-stack
description: Discovers one frontend, backend, or infrastructure area of a repository and produces an evidence-backed change-surface report. Use during parallel Universal Flow stack discovery before requirements planning.
---

# Discover Stack

Investigate exactly one area: `frontend`, `backend`, or `infrastructure`. Discovery is
read-only and evidence-first. Do not propose speculative architecture or edit code.

## Inputs

- bounded discovery packet
- target repository path
- area
- accepted PRD review path
- output path under the run root

Read only the artifacts and repository regions needed to answer the packet questions.
Apply the orchestrator human-readable output policy to created items and artifacts.

## Common discovery

Identify:

- project layout, ownership boundaries, and relevant entry points
- languages, frameworks, package/build tools, and repository-native commands
- existing patterns closest to each frontier item
- likely files, symbols, modules, and tests affected
- contracts crossing area boundaries
- the area's existing architecture and ADR locations, naming/index conventions, and
  relevant current documents
- existing diagram formats, Mermaid conventions, durable homes, and validation commands
- constraints, risks, unknowns, and assumptions requiring validation

Every material statement must cite a repository-relative path with line range or symbol,
a summarized command result, or an accepted artifact. Distinguish observed facts from
inferences.

Produce a current-state diagram only when repository evidence supports every component
and relationship complexity materially benefits from a visual. Embed it in the relevant
discovery report, follow the repository convention, and apply the orchestrator diagram
policy. Otherwise state that no discovery diagram is justified.

## Area focus

### Frontend

Inspect routing, composition, state management, forms, validation, accessibility,
loading/error/empty states, API clients, test conventions, and feature flags.

### Backend

Inspect transport contracts, domain models, validation, authorization, persistence,
transactions, idempotency, errors, observability, migrations, and test conventions.

### Infrastructure

Inspect local development and hosted environments together: configuration schema,
environment variables, secrets references, provisioning, deployment, networking,
permissions, migrations, observability, rollback, and CI/CD. Determine whether any
net-new resource blocks application implementation.

## Output contract

Write `discovery/<feature-slug>-<area>.md`:

```markdown
# [Area] Discovery
Status: complete | blocked
Display name:
Plain-language purpose:
Internal ID:

## Summary
## Evidence
## Existing architecture and conventions
### Durable documentation convention
- Architecture paths/indexes:
- ADR paths/indexes and numbering/status:
- Relevant current documents:
- Diagram conventions and validation tooling:
- Evidence or `none found`:
## Frontier change surfaces
- [frontier name and internal ID]
  - Likely files/symbols:
  - Existing analogous pattern:
  - Cross-area contracts:
## Native commands and checks
## Risks and constraints
## Unknowns and validation owners
## Open questions
## Planning recommendations
```

Planning recommendations identify constraints and reusable patterns, not a complete
solution. Do not invent requirements.

## Return

Return no more than ten bullets containing status, strongest findings, blocking unknowns,
and the report path. The orchestrator builds `discovery-index.md` from these summaries;
do not pass raw logs or repository dumps.
