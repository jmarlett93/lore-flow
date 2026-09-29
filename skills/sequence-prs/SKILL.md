---
name: sequence-prs
description: Splits human-approved Lore Flow requirements into dependency-aware frontend, backend, and infrastructure pull requests with bounded build packets. Use after pre-build Ponytail and human requirements approval.
---

# Sequence PRs

Create the smallest reviewable PR sequence that preserves requirement and runtime
dependencies.

## Inputs

- Ponytail-approved readable requirements artifact
- human requirements review approving its exact version
- discovery index
- decision log
- repository and PR constraints
- run artifact root

Apply the orchestrator human-readable output policy to PRs, sequence, packets, and
approval narration. Mint published `sequence.md` and terse per-PR notes per the
orchestrator published-docs policy. Keep packets in the run folder.

## Hard boundaries

Each PR has exactly one area:

- `frontend`
- `backend`
- `infrastructure`

Never mix areas in one PR, even for a small change. Split at named contracts and express
the dependency.

Assign every planned durable architecture document or ADR update to exactly one PR.
Domain documents follow their frontend, backend, or infrastructure owner. Cross-cutting
API/contract architecture belongs to the contract-producing backend PR by default.
Infrastructure documentation always remains in an infrastructure PR. If ownership is
genuinely ambiguous, block for a human decision; never create a mixed-area documentation
PR.

Default ordering is backend before frontend so the implemented contract exists before
its consumer. Frontend may lead only when independently reviewable and explicitly
approved. If it contains a control for an absent endpoint, its packet and PR description
must include exactly:

`button calls unimplemented endpoint - no-op for now`

Place infrastructure last unless a net-new resource blocks implementation. A blocking
resource is something application code cannot develop or verify without, not merely
configuration that is convenient to prepare first. Infrastructure scope must include
both local and hosted configuration and their validation.

## Sequencing process

1. Group named requirements by owning area and cohesive review purpose.
2. Split groups further when they can merge independently or carry distinct risk.
3. Create a directed dependency graph between PRs.
4. Apply ordering defaults and document every exception.
5. Ensure every requirement appears in exactly one primary PR.
6. Assign every durable architecture/ADR path exactly once and ensure its area matches.
7. Define contract assumptions for consumers and producers.
8. Generate one bounded build packet per PR using the orchestrator packet contract.
9. Check that no cycle exists; if one does, refine contracts or report a decision need.
10. When there is more than one PR, embed a Mermaid dependency DAG in published
    `sequence.md`. For one PR, state that no dependency diagram is needed.
11. Write one published PR note per item with links to architecture-overview facets and
    terse pseudo-code or a nominal-flow diagram for that PR only.

Do not sequence speculative cleanup, opportunistic refactors, or requirements rejected by
Ponytail.

## Output contract

Write published `docs/features/<feature-slug>/sequence.md` and `prs/*.md`. Keep the
detailed packet under the run folder.

```markdown
# Pull Request Sequence
Status: awaiting-human-review | blocked

## Ordering rationale
## Dependency graph
[embedded Mermaid DAG, or single-PR no-diagram statement]
## Sequence
### [PR name] ([internal PR ID])
- Meaning:
- Area: backend
- Requirements:
- Depends on:
- Contract produced/consumed:
- Durable architecture docs/ADRs owned:
- Architecture draft sources:
- Worktree branch intent:
- Acceptance checks:
- Packet: [readable packet path]
## Coverage
## Exceptions and approvals
## Risks and blockers
```

Each published PR note names the slice of the end state, links overview facets, and
includes only this PR's nominal flow or pseudo-code. Each run packet still states
objective, non-goals, scope, named requirements, dependencies, inputs, contracts,
checks, configuration duties, doc assignments, and the build-report path.

## Approval checkpoint

Mark ready for human review only when the graph is acyclic, areas are strictly separated,
ordering is justified, infrastructure covers local and hosted concerns, and all
requirements and durable documentation updates are covered exactly once. The required PR
DAG or single-PR no-diagram statement must be available at this checkpoint. Do not mark
the sequence or packets approved and do not start builds. Return the published sequence
and PR-note paths, exact versions, parallelizable PRs, and blockers.
