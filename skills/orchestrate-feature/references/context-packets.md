# Context Packet Contract

Agents exchange artifacts and bounded packets, never transcripts. A packet should be
small enough to inspect in one pass; target 800 words and do not exceed 1,500 words
excluding direct file references.

## Required packet fields

- `packet-id`, `run-id`, and intended role
- objective and explicit non-goals
- target repository and allowed scope
- accepted input artifact IDs, versions, and paths
- relevant named requirement IDs
- decisions that constrain the task
- dependencies and current status
- required outputs and exact destination paths
- verification expectations
- blockers or questions the recipient may escalate

Include evidence excerpts only when a path and symbol are insufficient. Never include
chat history, hidden reasoning, full discovery logs, or unrelated source files.

## Discovery packet

Add:

- area: `frontend`, `backend`, or `infrastructure`
- PRD frontier summary
- questions the report must answer
- known repository entry points, if any

The result must provide observed evidence, conventions, likely change surfaces, commands,
risks, unknowns, and existing architecture/ADR paths and relevant documents. Discovery
does not design or edit.

## Planning packet

Add:

- accepted PRD review path
- discovery index and three discovery report paths
- product decisions and constraints

The result must use named model/contract/state/behavior requirements and a dependency
graph. Include architecture impact, durable target paths, and only meaningful versioned
run-draft outputs. It must not rely on unstated transcript context.

## Build packet

Add:

- PR ID, area, purpose, base dependency, and worktree/branch policy
- exact requirement IDs in scope
- acceptance checks and repository-native test commands
- allowed paths or components and explicit exclusions
- contracts consumed or exposed
- rollout/configuration duties
- assigned durable architecture/ADR paths and versioned run-draft sources
- architecture/ADR paths explicitly outside this PR's ownership
- required build-report path
- approving sequence review ID and approved packet/input versions

For infrastructure, specify both local and hosted configuration acceptance. For an
approved frontend-leading stub, include exactly:

`button calls unimplemented endpoint - no-op for now`

The builder may inspect the repository for implementation details but must escalate any
change that expands named requirements, crosses area boundaries, or touches an
unassigned architecture document. It verifies changed documentation links, examples,
commands, and configuration references.

Before mutation, the builder verifies that the packet and every accepted input version
match the approving review and artifact index. Reject any draft, invalidated, replaced,
or superseded version. Human approval of a different version does not carry forward.

## Review packet

Add:

- review mode: `pre-build` or `post-build`
- baseline artifact IDs
- diff reference for post-build review
- checks already run and summarized results

The result separates blocking findings, non-blocking findings, rejected concerns, and
evidence. Every finding names the violated requirement, observed risk, or YAGNI reason.

## Human gate packet

Add:

- gate ID and reason
- reviewer or reviewer policy
- exact artifact IDs and versions to review
- concise change summary, decisions, risks, and unresolved questions
- allowed decisions: `approved`, `changes-requested`, or `rejected`
- effect of each decision and resume instructions

Do not ask for approval of an unversioned artifact. A human edit is a proposed change and
must be reconciled through `realign-run`, not treated as approval.

## Realignment packet

Keep this packet at 800 words or fewer. Add:

- review ID, reviewer, decision, comments, and changed artifact versions
- classifications and old/new names or design facts
- affected architecture draft versions and durable documentation paths
- relevant dependency edges, alias entries, and current invalidation records
- accepted artifacts that must remain preserved
- affected branches, worktrees, packets, builds, and their current state
- requested output path and current pending gate

Include only the graph slice reachable from changed artifacts plus immediate evidence.
The result returns proposed aliases, transitive impacts, minimal reruns, implementation
actions requiring approval, preserved artifact versions, and the next human gate.

## Return packet

Every delegated task returns no more than:

- outcome: `accepted`, `changes-required`, or `blocked`
- summary of at most ten bullets
- created or updated artifact IDs and paths
- evidence/check summary
- decisions or blockers requiring parent action

Full detail belongs in the indexed artifact. The parent consumes the return packet and
artifact index, not the agent transcript.
