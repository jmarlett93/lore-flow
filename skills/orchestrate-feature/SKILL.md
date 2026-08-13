---
name: orchestrate-feature
description: Runs or resumes Universal Flow through discovery, planning, approval checkpoints, sequenced builds, review, realignment, and reporting.
---

# Orchestrate Feature

Run Universal Flow without assuming a specific agent harness. Delegate by capability,
persist artifacts in the target repository, and keep the parent context small.

## Inputs

Require:

- target repository path
- PRD path or authoritative requirement source
- selected preset name

Accept optional constraints: issue or branch references, excluded paths, required checks,
PR policy, deployment environments, required reviewers, extra per-PR approval policy,
and user decisions already made.

Load `config/presets.json` from the Universal Flow installation, select the named preset,
and resolve its harness plus role/model mappings. Treat preset values as configuration,
not workflow semantics. If the preset, harness adapter, or required role is unavailable,
stop with a precise missing-input report; never silently substitute a harness or model.

## Run setup

Create a unique `run-id` and use this artifact root in the target repository:

`.universal-flow/runs/<run-id>/`

Initialize the run and artifact index according to
[run-schema.md](references/run-schema.md). Read
[context-packets.md](references/context-packets.md),
[diagram-policy.md](references/diagram-policy.md),
[human-readable-output.md](references/human-readable-output.md), and
[published-docs.md](references/published-docs.md) before delegating.
Include those policies and relevant assignments in every packet.

`.universal-flow/` is run machinery. If the target repository has no ignore rule for it,
add the template at `templates/gitignore`. Human approval uses the published pack under
`docs/features/<feature-slug>/`, not the run folder.

The parent retains only:

- current phase, decisions, blockers, and artifact index
- short summaries with paths to full evidence
- the bounded packet needed for the next delegation

Never forward transcripts, raw agent conversations, or unbounded command output.

## Workflow

### 1. Review the PRD frontier

Invoke `review-prd`. Establish the exact frontier between current behavior and requested
behavior. Do not proceed while critical ambiguity, contradictory acceptance criteria, or
an unowned product decision remains open. Persist the readable PRD review path.

### 2. Discover the stack in parallel

Invoke `discover-stack` independently for:

- frontend
- backend
- infrastructure

Run these concurrently when the harness permits. Give each only the PRD summary,
frontier, target path, scope, and relevant known constraints. Persist one evidence-backed
report per area and a compact `discovery-index.md`.
Each report identifies existing architecture/ADR conventions and relevant current docs.
It also identifies repository-native diagram conventions and any available validation
tooling.

### 3. Plan technical requirements

Invoke `plan-requirements` with the PRD review and discovery summaries. Every proposed
change must become a named requirement for a model, contract, state, or behavior change.
Persist the run requirements path as evidence. Mint the published pack before the
requirements approval checkpoint: systems summary, technical spec, and end-state
architecture overview with simple object models, contracts, and justified diagrams.
Keep versioned drafts in the run folder. Present the published files, not the run
folder, at the checkpoint.

### 4. Run pre-build Ponytail review

Invoke `ponytail` in `pre-build` mode. Require an adversarial YAGNI review that challenges
scope, abstractions, speculative infrastructure, and requirements unsupported by the
frontier. Update requirements only from evidence or an explicit user decision. Persist
the readable pre-build review and decision paths.

### 5. Obtain human requirements approval

After Ponytail accepts the technical requirements, pause at the requirements approval
checkpoint. Present the published systems summary, technical spec, and architecture
overview first. Add numbered named actions, consequences, versions, and `Open questions`.
Record the review.

Resume only after explicit human approval of that exact requirements version. Silence,
edits, or an agent's interpretation are not approval. If the reviewer requests changes,
invoke `realign-run`, preserve prior accepted artifacts, and explain the earliest
approval checkpoint that must be repeated.

### 6. Sequence pull requests

Invoke `sequence-prs`. Split PRs strictly into `frontend`, `backend`, or
`infrastructure`; never create mixed-area PRs. Default to backend before frontend.
Infrastructure is last unless a net-new resource blocks implementation. Infrastructure
must cover both local and hosted configuration. Persist packets in the run folder.
Mint published `sequence.md` and one terse PR note per item that links to overview
facets and includes pseudo-code or a nominal flow for that PR only. Assign each
durable architecture/ADR change exactly once without mixed-area PRs. For multiple PRs,
include the DAG in published `sequence.md`.

If frontend must lead while its backend endpoint is absent, include this exact note:

`button calls unimplemented endpoint - no-op for now`

### 7. Obtain human sequence approval

Pause at the sequence approval checkpoint after generating the sequence and all packets,
before creating or changing a build worktree. Present published `sequence.md` and PR
notes first, then numbered named actions, consequences, versions, and `Open questions`.
Persist the review.

Resume only after explicit approval of the exact sequence and packet versions. On edits
or requested changes, invoke `realign-run` and return to the earliest impacted approval
checkpoint.
These requirements and sequence approval checkpoints are mandatory for every preset.

### 8. Build in worktrees

Invoke `build-pr` once per sequence item, respecting dependencies. Each build runs in a
dedicated git worktree and receives only its build packet plus referenced artifacts.
Agents must inspect current repository state before editing and must not reuse another
PR's worktree. Verify the packet and every input version match the approved sequence
review; reject stale or superseded versions. Persist build reports and diffs or diff
references.
Builders update only their assigned published PR note, owned overview facets, and
durable architecture docs. They carry over approved diagrams and verify links, examples,
configuration references, and diagram syntax against the implementation.

Per-PR human approval is on by default. Before each PR build, set status to
`awaiting-human-review` and apply the same exact-version review of that PR note.
Skip only when the preset sets `each-pr: false`. This checkpoint supplements, and
never replaces, the two mandatory checkpoints.

### 9. Run post-build Ponytail review

Invoke `ponytail` in `post-build` mode for every PR diff. The review must be antagonistic:
seek unnecessary code, hidden coupling, contract drift, weak tests, accidental scope,
and mismatches with the named requirements. Fix blocking findings in the same worktree,
retest, and repeat review until accepted or explicitly blocked. Persist each review.

### 10. Produce the final report

Invoke `final-report` after all reachable PRs finish. Report outcomes, ordering,
requirement coverage, checks, unresolved risks, deferred work, and artifact paths.
Include indexed architecture draft versions, diagram coverage and validation evidence,
and durable documentation coverage. Persist the readable final report; return its concise
executive summary to the user.

## Approval and execution rules

- No build before explicit human approval of Ponytail-approved requirements and the
  generated PR sequence with its packets.
- No resume from `awaiting-human-review` without a review record approving exact current
  artifact versions.
- No build from a stale, invalidated, or superseded packet.
- No dependent PR before its blocking predecessor is ready.
- No claim without evidence or an explicit `unknown`.
- No context packet that exceeds the bounds in the context contract.
- No final success claim when required checks, reviews, or artifacts are missing.

When review is pending, preserve completed artifacts, use `awaiting-human-review`, and
report the reviewer action and exact version needed to resume. When blocked, report the
smallest decision or action needed. Never infer approval or silently realign.
