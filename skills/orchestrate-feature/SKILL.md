---
name: orchestrate-feature
description: Orchestrates Universal Flow through discovery, requirements, mandatory human approvals, realignment, sequenced worktree builds, adversarial review, and final reporting. Use when running or resuming the complete feature-delivery workflow.
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
[context-packets.md](references/context-packets.md) before delegating.

The parent retains only:

- current phase, decisions, blockers, and artifact index
- short summaries with paths to full evidence
- the bounded packet needed for the next delegation

Never forward transcripts, raw agent conversations, or unbounded command output.

## Workflow

### 1. Review the PRD frontier

Invoke `review-prd`. Establish the exact frontier between current behavior and requested
behavior. Do not proceed while critical ambiguity, contradictory acceptance criteria, or
an unowned product decision remains open. Persist `prd-review.md`.

### 2. Discover the stack in parallel

Invoke `discover-stack` independently for:

- frontend
- backend
- infrastructure

Run these concurrently when the harness permits. Give each only the PRD summary,
frontier, target path, scope, and relevant known constraints. Persist one evidence-backed
report per area and a compact `discovery-index.md`.
Each report identifies existing architecture/ADR conventions and relevant current docs.

### 3. Plan technical requirements

Invoke `plan-requirements` with the PRD review and discovery summaries. Every proposed
change must become a named requirement for a model, contract, state, or behavior change.
Persist `requirements.md`, including dependencies, acceptance checks, ownership, and
traceability to PRD evidence. For meaningful architecture changes, also persist versioned
source drafts under `architecture/`; create only relevant domain drafts and warranted ADR
drafts. These run artifacts do not replace durable target-repository documentation.

### 4. Run pre-build Ponytail review

Invoke `ponytail` in `pre-build` mode. Require an adversarial YAGNI review that challenges
scope, abstractions, speculative infrastructure, and requirements unsupported by the
frontier. Update requirements only from evidence or an explicit user decision. Persist
`ponytail-pre-build.md` and a decision log.

### 5. Obtain human requirements approval

After Ponytail accepts the technical requirements, set the run status to
`awaiting-human-review` and stop. Present the accepted artifact version, Ponytail outcome,
material decisions, and unresolved risks. Record reviewer identity, decision, timestamp,
comments, and reviewed artifact version.

Resume only after explicit human approval of that exact requirements version. Silence,
edits, or an agent's interpretation are not approval. If the reviewer requests changes,
invoke `realign-run`, preserve prior accepted artifacts, and return to the earliest
impacted gate.

### 6. Sequence pull requests

Invoke `sequence-prs`. Split PRs strictly into `frontend`, `backend`, or
`infrastructure`; never create mixed-area PRs. Default to backend before frontend.
Infrastructure is last unless a net-new resource blocks implementation. Infrastructure
must cover both local and hosted configuration. Persist `pr-sequence.md` and one bounded
build packet per PR. Assign each required durable architecture/ADR change exactly once
without weakening area separation; block when ownership cannot be resolved.

If frontend must lead while its backend endpoint is absent, include this exact note:

`button calls unimplemented endpoint - no-op for now`

### 7. Obtain human sequence approval

Set status to `awaiting-human-review` after generating `pr-sequence.md` and all packets,
before creating or changing any build worktree. Present the sequence version, packet
versions, ordering, dependencies, and exceptions. Persist reviewer identity, decision,
timestamp, comments, and reviewed versions.

Resume only after explicit approval of the exact sequence and packet versions. On edits
or requested changes, invoke `realign-run` and return to the earliest impacted gate.
These requirements and sequence gates are mandatory for every preset and policy.

### 8. Build in worktrees

Invoke `build-pr` once per sequence item, respecting dependencies. Each build runs in a
dedicated git worktree and receives only its build packet plus referenced artifacts.
Agents must inspect current repository state before editing and must not reuse another
PR's worktree. Verify the packet and every input version match the approved sequence
review; reject stale or superseded versions. Persist build reports and diffs or diff
references.
Builders update only their assigned durable architecture docs in the repository and
verify links, examples, and configuration references against the implementation.

If the preset or PR policy requires per-PR human approval, set status to
`awaiting-human-review` before that PR build and apply the same exact-version review
record. This configurable gate supplements, and never replaces, the two mandatory gates.

### 9. Run post-build Ponytail review

Invoke `ponytail` in `post-build` mode for every PR diff. The review must be antagonistic:
seek unnecessary code, hidden coupling, contract drift, weak tests, accidental scope,
and mismatches with the named requirements. Fix blocking findings in the same worktree,
retest, and repeat review until accepted or explicitly blocked. Persist each review.

### 10. Produce the final report

Invoke `final-report` after all reachable PRs finish. Report outcomes, ordering,
requirement coverage, checks, unresolved risks, deferred work, and artifact paths.
Include indexed architecture draft versions and durable documentation coverage. Persist
`final-report.md`; return its concise executive summary to the user.

## Gates

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
