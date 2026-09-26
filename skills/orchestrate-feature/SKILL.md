---
name: orchestrate-feature
description: Runs or resumes Universal Flow through technical specs, Ponytail review, parallel builds, targeted recovery, and reporting.
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

### 1. Create technical specs

The Opus orchestrator invokes `review-prd` and only the necessary `discover-stack`
workers. Frontend, backend, and infrastructure discovery run concurrently when they
touch independent areas. Then `plan-requirements` emits one technical-spec packet per
independent implementation unit.

Each packet names the requirement frontier, owned files, contracts, side effects,
dependencies, acceptance checks, and the smallest implementation that satisfies the
requirement. Before publishing a packet, create its guidance manifest at
`.universal-flow/runs/<run-id>/guidance/<packet-id>.md`. Inspect the target repository's
`AGENTS.md`, applicable `.cursor/rules/`, `.agents/skills/`, and any nested instruction
files. Record only applicable paths, why they apply, their content hashes, and
`required` / `recommended` / `not-applicable` status; do not copy their contents.
Persist the requirements, architecture overview, guidance manifests, packet index, and
versions in the run artifacts. The packet dependency graph is the execution plan.

### 2. Review the specs

Invoke `ponytail` against the complete technical-spec set before any build. It challenges
YAGNI, unnecessary abstractions, speculative infrastructure, scope drift, missing
validation, and missing tests. The Opus orchestrator repairs rejected specs and reruns
the review until the set is accepted or explicitly blocked.

Pause once for human approval of the Ponytail-approved technical-spec version. Do not
start builders until that exact version is approved. The `cursor.simple` preset disables
the separate PR-sequence and per-PR approval gates.

### 3. Build and review in parallel

Dispatch one `build-pr` worker per ready packet in a dedicated git worktree. Use only
the packet, relevant repository instructions, dependency outputs, and approved
artifacts. Independent packets run concurrently; dependent packets wait for their
declared prerequisites.

When a builder finishes, immediately invoke `ponytail` against that unit's diff and
validation evidence. The review looks for unnecessary code, hidden coupling, contract
drift, weak tests, accidental scope, and mismatch with the approved packet. Send only
rejected units to repair and rerun their checks and review. Accepted units remain
complete while other units continue.

### 4. Recover and report

The Opus orchestrator reads `run.md`, `artifact-index.md`, packet versions, worktree
state, commits, checks, and review findings. For a failure, preserve the failed
worktree and evidence, then retry or repair only that unit. Do not restart accepted
units.

If a repair changes a contract, mark dependent packets stale, regenerate only those
packets, and return them to Ponytail spec review. If state disagrees with Git or the
filesystem, preserve both views and block for reconciliation. Never infer success from
chat history.

Invoke `final-report` after all reachable units finish. Report each unit, checks,
Ponytail findings, unresolved risks, deferred work, artifact paths, and blocked
recovery actions.

## Approval and execution rules

- No build before explicit human approval of the Ponytail-approved technical-spec set.
- No resume from a failed or awaiting-review state without reading persisted artifacts.
- No build from a stale, invalidated, or superseded packet.
- No dependent unit before its blocking prerequisite is ready.
- No cleanup of failed worktrees or branches until recovery is complete.
- No claim without evidence or an explicit `unknown`.
- No context packet that exceeds the bounds in the context contract.
- No final success claim when required checks, reviews, or artifacts are missing.

When review is pending, preserve completed artifacts and report the exact action needed.
When blocked, report the smallest decision or reconciliation needed. Never silently
realign or discard work.
