# Universal Flow

Universal Flow is a portable, skills-only workflow plugin for turning a product
requirement into a sequenced set of implementation branches and reviews. It
does not ship a runtime, service, or project template. The workflow lives in
one canonical root `skills/` directory so Cursor and Claude Code execute the
same instructions.

Harness-specific agents are deliberately thin. They translate a harness's
agent, model, and tool conventions into calls to the canonical skills; they do
not duplicate workflow policy. This keeps behavior consistent while still
allowing each harness to use its native delegation and review features.

## Presets

Universal Flow offers two operating presets:

- **normal** favors short plans, a small number of agents, and focused reviews;
  use it for routine changes with known boundaries.
- **heavy** adds deeper decomposition, stricter dependency gates, and more
  review passes; use it for migrations, cross-system work, or high-risk changes.

A preset is a starting policy, not a promise that a particular model or amount
of parallelism is available. Select the harness-qualified key from
`config/presets.json`, such as `cursor.normal` or `claude.heavy`.

## Compatibility

Universal Flow can operate against any repository opened by a current Cursor or
Claude Code installation, subject to these requirements:

- The target must be a Git repository because builders use branches and worktrees.
- The harness must support plugins, custom subagents, skills, and worktrees.
- At least one configured model candidate must be available for every required role.
- The user must have permission to create worktrees and, when requested, branches or PRs.
- Repository-specific setup, test commands, credentials, and coding-standard skills remain
  the target repository's responsibility.

Planning can run without a remote. Creating pull requests requires a configured remote and
the harness's normal Git hosting authentication.

## Install

Clone or vendor Universal Flow at a stable path outside the target repository:

```bash
git clone YOUR_UNIVERSAL_FLOW_REPOSITORY_URL "$HOME/tools/universal-flow"
export UNIVERSAL_FLOW_HOME="$HOME/tools/universal-flow"
```

The installation contains one canonical `skills/` directory. Cursor loads
`.cursor-plugin/plugin.json`; Claude Code loads `.claude-plugin/plugin.json`. Do not copy
or maintain separate harness-specific skill implementations.

### Cursor Desktop

Load the plugin for every Cursor workspace by linking it into Cursor's local plugin
directory:

```bash
mkdir -p ~/.cursor/plugins/local
ln -s "$UNIVERSAL_FLOW_HOME" ~/.cursor/plugins/local/universal-flow
```

Restart Cursor or run **Developer: Reload Window**. In Cursor's customization view,
confirm that the `universal-flow` plugin, its skills, and its custom agents are listed.

On Windows, use a directory junction or copy the plugin into
`%USERPROFILE%\.cursor\plugins\local\universal-flow`.

### Cursor CLI

Load Universal Flow for one session without installing it globally:

```bash
cd /path/to/target-repository
agent --workspace "$PWD" --plugin-dir "$UNIVERSAL_FLOW_HOME"
```

The `--plugin-dir` option is useful for testing changes to Universal Flow before updating
a shared installation.

### Claude Code

Load Universal Flow for one session from the target repository:

```bash
cd /path/to/target-repository
claude --plugin-dir "$UNIVERSAL_FLOW_HOME"
```

Confirm it appears in `/plugin`. Plugin skills are namespaced, so the orchestration skill
is available as `/universal-flow:orchestrate-feature`.

For persistent team installation, publish Universal Flow through a Claude Code plugin
marketplace, then install it at project scope:

```bash
claude plugin marketplace add MARKETPLACE_SOURCE
claude plugin install universal-flow@MARKETPLACE_NAME --scope project
```

This repository currently contains the plugin manifests but not a marketplace catalog;
until one is published, use `--plugin-dir` or a managed local installation.

### Update or remove

For a cloned installation, update it with the repository's normal Git workflow, then
reload the harness. Remove a Cursor local installation by deleting only the
`~/.cursor/plugins/local/universal-flow` link. Session-only `--plugin-dir` loading leaves
no installation in the target repository.

## Verify the installation

Before the first build run:

1. Confirm all Universal Flow skills and harness agents are visible.
2. Confirm the selected key exists in `config/presets.json`.
3. Confirm the configured model candidates are available to the account.
4. Confirm the target repository is a clean, usable Git checkout.
5. Run planning first and verify that it pauses at the mandatory requirements review.

## Invoke a run

Invoke the Universal Flow orchestration skill with:

1. a PRD, issue, or concise change description;
2. the target repository and base branch;
3. a harness-qualified preset such as `cursor.normal` or `claude.heavy`; and
4. any required reviewers, model preferences, or repository constraints.

For Cursor, invoke `/orchestrate-feature` or ask:

> Run Universal Flow with `cursor.normal` for this PRD against `main`.

For Claude Code, invoke:

```text
/universal-flow:orchestrate-feature Run with claude.normal for this PRD against main.
```

The orchestrator decomposes the request, records dependencies, and dispatches
only work whose prerequisites are satisfied.

## Run artifacts

Each run writes durable state under the target repository:

```text
.universal-flow/runs/<run-id>/
├── run.md
├── artifact-index.md
├── prd-review.md
├── discovery/
├── requirements.md
├── architecture/
│   ├── overview.md
│   ├── frontend.md, backend.md, infrastructure.md (only when relevant)
│   └── adr/ (only warranted decision drafts)
├── pr-sequence.md
├── packets/
├── human-reviews/
├── realignments/
├── builds/
├── reviews/
└── final-report.md
```

`run.md` records status, phase, constraints, decisions, and blockers.
`artifact-index.md` links every durable input and output with its evidence and
acceptance state. The other human-readable artifacts hold discovery,
requirements, dependency sequencing, bounded build packets, worktree results,
and reviews. Preserve superseded decisions instead of silently overwriting
them; recovery must not depend on replaying chat text.

### Architecture documentation

Run-scoped files in `architecture/` are versioned design drafts and evidence for the
current run. Planning creates them only for meaningful boundary, contract, data-flow,
deployment, or design-decision changes—not trivial implementation details.

Delivered architecture documentation is updated in the target repository's existing
convention discovered for each area. If no convention exists, use
`docs/architecture/` for architecture documents and `docs/adr/` for ADRs. Run drafts
remain source material and never substitute for committed durable docs.

Sequencing assigns each durable document change to exactly one area-owned PR. Domain
documents follow their domain; cross-cutting API/contract docs default to the
contract-producing backend PR; infrastructure docs stay in infrastructure PRs.
Ambiguous ownership blocks for human decision instead of creating a mixed-domain PR.

## Human review and realignment

Every run pauses twice before builds:

1. after Ponytail accepts the technical requirements; and
2. after the PR sequence and build packets are generated.

At each pause, status is `awaiting-human-review`. The reviewer receives concise
artifact links and exact versions. Universal Flow records the reviewer's
identity, decision, timestamp, comments, and reviewed versions, then resumes
only on explicit approval. Presets may add per-PR approval, but cannot remove
the two mandatory gates.

Reviewers may edit names, requirements, design, scope, or sequence and request
changes. Invoke `realign-run` with the run ID and review record. It preserves
accepted history, records rename aliases, computes transitive impact, and
supersedes only affected downstream artifacts. Unaffected accepted work stays
valid, and the run returns to the earliest impacted human gate.

When builds or worktrees already exist, realignment proposes `keep`, `rebase`,
`replace`, or `cancel` for each affected unit. It does not mutate or discard
that work until a human explicitly approves the action. To resume, invoke the
orchestrator with the run ID and an approval naming the current artifact
versions; silence or edited files alone are never approval.

Generated run artifacts should normally remain uncommitted. A target repository
may ignore them or archive selected artifacts according to its own policy.

## Branch and worktree lifecycle

Each implementation unit gets its own branch and worktree. A worker may change
only that unit's declared scope. It commits locally when the harness workflow
requires a handoff, then records the commit and verification evidence in the
unit artifact.

The orchestrator keeps the base checkout stable, integrates units in dependency
order, and never reuses a dirty worktree. Successful worktrees can be removed
after their commits are safely integrated. Failed or interrupted worktrees and
branches are preserved until recovery is complete; cleanup must not discard
uncommitted work.

## Sequencing rules

Dependencies describe what must be usable before another unit can complete,
not merely which section appeared first in the PRD.

- Prefer backend or contract providers before consumers.
- Frontend may come first only when it is intentionally a no-op or can operate
  against an existing stable contract; record the exception explicitly.
- Existing, non-blocking infrastructure adjustments may land late.
- Net-new infrastructure that blocks build, deploy, test, or runtime must land
  before dependent application work.
- Contract migrations use an expand/migrate/contract sequence: add a compatible
  provider, migrate every consumer, then remove the old contract.
- A failed required review blocks integration and downstream dependents. Fix
  the same unit and rerun that reviewer rather than treating review as advisory.

Independent units may run in parallel. A unit becomes ready only when every
declared prerequisite has reached its required completion or review state.

## Context management

Treat run artifacts as the source of truth. Give workers the smallest useful
context: the unit brief, relevant files, dependency outputs, repository
standards, and acceptance checks. Keep broad PRD interpretation and graph
management in the orchestrator. Summaries should point to artifacts and commits
instead of copying long transcripts between agents.

When context becomes crowded, start a fresh worker from the recorded unit state
rather than relying on conversational memory.

## Resume and recovery

To resume, invoke the orchestration skill with the run ID. The orchestrator
reads `run.md` and `artifact-index.md`, verifies indexed artifacts, branches,
worktrees, commits, and reviews against the repository, then continues only
ready work.

If recorded state disagrees with Git or the filesystem, preserve both, mark the
unit blocked, and require reconciliation. Do not silently recreate branches,
discard worktrees, skip a failed review, or infer success from a previous chat.

## Models and fallbacks

Model names are preferences interpreted by the active harness. Availability can
vary by account, policy, region, and harness release. Presets may list ordered
model candidates, but the harness must resolve the selected model explicitly
and record it. If the preset, adapter, required role, or permitted model is
unavailable, stop and report the missing capability; never invent a fallback or
silently weaken a required review.

## Repository coding standards

Universal Flow supplies workflow skills, not target-specific coding policy.
Target repositories should expose their coding standards as discoverable skills
in the locations supported by each harness. A repository can keep standards in
one canonical directory and link each skill into `.cursor/skills/` and
`.claude/skills/`; there is no need to maintain divergent copies. Keep those
skills narrow and actionable—for example, TypeScript conventions, test
commands, accessibility checks, database migration rules, or release
requirements—and reference them from repository agent guidance when necessary.

Workers load the applicable target-repository skills before editing and record
which standards guided the unit. Repository instructions override generic
workflow examples when they do not violate a run's explicit safety gates.
