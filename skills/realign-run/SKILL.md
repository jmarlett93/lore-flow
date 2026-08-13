---
name: realign-run
description: Reconciles explicit human edits or review changes, preserves history, computes downstream impact, and returns the next approval checkpoint. Use when a reviewer changes accepted planning artifacts.
---

# Realign Run

Reconcile human changes without silently rewriting an accepted plan. Preserve accepted
artifacts, decisions, and implementation work until the reviewer approves a safe path.

## Inputs

Require:

- run ID and run artifact root
- reviewer identity
- review decision and comments
- changed naming, requirement, design, sequencing, or scope artifacts
- current run manifest, artifact index, decisions, reviews, and dependency graph

Also inspect existing branches, worktrees, and build reports when implementation exists.
Treat direct human edits as proposed changes, not implicit approval.
Apply the orchestrator human-readable output policy throughout.

## Classify the change

Assign every change one or more classes:

- `rename-only`: labels change, but meaning and acceptance stay equivalent
- `requirement`: frontier, acceptance, ownership, or necessity changes
- `contract-model-state-behavior-design`: a technical design boundary changes
- `sequencing`: PR grouping, dependencies, order, or parallelism changes
- `scope`: included, excluded, deferred, or cross-area work changes

If a rename changes meaning, classify the semantic change too. Record uncertainty and ask
the reviewer; never downgrade a change to reduce reruns.

For every design or naming change, record impact on the published spec, architecture
overview, sequence, PR notes, run drafts, and durable architecture/ADR paths. A design change regenerates only affected drafts
and revalidates their durable-doc assignments. A `rename-only` change preserves aliases,
stable IDs, and decision history, and refreshes only documents that contain the affected
name; it does not rewrite unrelated architecture.

Apply the same bounds to embedded diagrams. Refresh only diagrams reached by the changed
requirements, contracts, topology, state, or sequence; preserve unaffected diagrams.
For `rename-only`, use the alias map to refresh affected labels while keeping stable node
IDs and relationships. Revalidate changed diagrams without creating decorative ones.

## Preserve history

1. Snapshot each changed accepted artifact as its existing immutable version.
2. Create a new candidate version linked to its predecessor and review record.
3. Keep prior accepted decisions and artifacts addressable.
4. Record why each new version differs and who requested it.
5. Mark an artifact `superseded` only after its replacement is accepted.

For `rename-only`, add old-to-new names to the alias map. Keep stable IDs where meaning is
unchanged and preserve reverse traceability from the new label to prior evidence,
requirements, packets, builds, and reviews.
Change a readable filename only through the explicit realignment plan. Preserve its
stable ID and record old/new path aliases so earlier references remain traceable.

## Compute transitive impact

Start from changed artifact IDs and traverse declared input, requirement, contract, and PR
dependency edges. Produce one impact record per reachable artifact:

- source change and classification
- dependency path that makes the artifact reachable
- impact: `none`, `label-refresh`, `revalidate`, or `regenerate`
- affected architecture draft versions and durable document/ADR paths
- rationale and proposed action

Do not invalidate an artifact merely because it is later in time. Unaffected branches of
the graph remain accepted. A rename normally requires alias-aware label refresh, not
design or build invalidation. A changed contract invalidates only its requirements,
producer/consumer sequence nodes, packets, and builds that rely on that contract.

## Select the minimal rerun

Use the earliest materially impacted phase:

- PRD review for changed product scope or frontier
- discovery only when repository facts must be re-observed
- requirements planning for requirement or technical design changes
- pre-build Ponytail for any materially changed requirements
- PR sequencing for dependency, grouping, area, or order changes
- packet generation for affected PRs only
- build and post-build review for affected implementation only

Mark only impacted downstream versions `superseded` after replacement approval. Reuse
unaffected accepted versions by exact artifact ID and version. Never silently adapt a
packet, sequence, build, or review.

## Existing implementation safety

If branches, worktrees, commits, or builds exist, describe their current state and propose
one action for each affected unit:

- `keep`: still valid against approved artifacts
- `rebase`: retain work on a newly approved dependency or base
- `replace`: preserve evidence, then rebuild from a replacement packet
- `cancel`: preserve the worktree/branch record and stop the unit

State data-loss, conflict, and review risks. Require explicit human approval before
rebasing, deleting, replacing, resetting, force-updating, or cancelling implementation.
Until approval, leave implementation untouched and set status `awaiting-human-review`.
Present every destructive action as its own numbered approval item. Name the exact file,
worktree, or branch and consequence; never combine it with another approval.

## Output

Write `realignments/<change-slug>.md` containing:

- run and realignment IDs, reviewer, decision, comments, and timestamp
- changed artifact IDs and before/candidate versions
- change classifications and alias updates
- published pack, architecture draft, and durable-document impact
- impacted diagrams, preserved diagrams, and validation needed
- transitive impact records and unaffected accepted artifacts
- minimal phases and affected PRs to rerun
- existing-build proposals and approvals required
- supersession plan, unresolved questions, and next approval checkpoint
- display name, plain-language purpose, internal ID, old/new path aliases, named numbered
  decisions and consequences, and a separate `Open questions` section

Update the artifact index, decision history, review records, and run status without
overwriting prior entries. Return a bounded summary with the artifact path.

## Approval checkpoint

The next approval checkpoint is the earliest impacted mandatory checkpoint: technical
requirements or PR sequence. If neither is materially impacted, request approval of the
realignment plan before resuming. Explain what changed, what is no longer trustworthy,
and what needs review. Resume only from approval naming the candidate versions.
