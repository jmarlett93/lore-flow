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

Universal Flow offers three operating presets:

- **normal** favors short plans, a small number of agents, and focused reviews;
  use it for routine changes with known boundaries.
- **heavy** adds deeper decomposition, stricter dependency gates, and more
  review passes; use it for migrations, cross-system work, or high-risk changes.
- **simple** uses one Opus-led spec/recovery loop, Ponytail gates, and parallel
  Cursor builders; use it when independent technical specs can be implemented
  concurrently.

A preset is a starting policy, not a promise that a particular model or amount
of parallelism is available. Select the harness-qualified key from
`config/presets.json`, such as `cursor.simple`, `cursor.normal`, or
`claude.heavy`.

## Product spec mode

Universal Flow also provides a separate `product-spec` mode for turning an idea
or product change into an approved PRD before implementation planning. It is a
human-in-the-loop interview and review loop, not a build preset:

```text
idea or change → product context → focused interview → PRD review
             → human approval → product/prds/<feature-slug>.md
```

Invoke `/product-spec` (or ask the active harness to run Universal Flow's
product-spec mode) against a target repository. The mode reads and, when
missing, bootstraps this durable context:

```text
product/
├── CURRENT_PRODUCT_STATE.md
├── PERSONAS.md
├── GLOSSARY.md
└── prds/
    └── <feature-slug>.md
```

Existing product documents are evidence, not disposable input. The product
agent preserves them, identifies conflicts, and asks about unresolved product
choices. `CURRENT_PRODUCT_STATE.md` remains a record of current behavior; a
proposed change belongs in the PRD. After the PRD is explicitly approved, pass
its path to `/orchestrate-feature` when implementation is wanted. Product spec
mode never launches builders automatically.

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

### Optional Herdr adapter

Herdr users can select `herdr` as the execution adapter. The adapter creates one
workspace and `agents` tab for the run, then launches each Cursor builder in a real
child pane while Universal Flow retains ownership of packets, worktrees, reviews, and
recovery. See [adapters/herdr/README.md](adapters/herdr/README.md).

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

For persistent installation, add this repository as a Claude Code marketplace and install
the plugin. Project scope records the installation in the target repository:

```bash
claude plugin marketplace add jmarlett93/universal-flow
claude plugin install universal-flow@universal-flow --scope project
```

After a release version is published, update an existing installation with:

```bash
claude plugin update universal-flow@universal-flow
```

For local development, continue to use `--plugin-dir`; it loads the checked-out files
directly without marketplace caching.

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
5. Run planning first and verify that it pauses at the technical-spec review.

## Invoke a run

Invoke the Universal Flow orchestration skill with:

1. a PRD, issue, or concise change description;
2. the target repository and base branch;
3. a harness-qualified preset such as `cursor.simple`, `cursor.normal`, or
   `claude.heavy`; and
4. any required reviewers, model preferences, or repository constraints.

For Cursor, invoke `/orchestrate-feature` or ask:

> Run Universal Flow with `cursor.simple` for this PRD against `main`.

For Claude Code, invoke:

```text
/universal-flow:orchestrate-feature Run with claude.normal for this PRD against main.
```

The orchestrator decomposes the request, records dependencies, and dispatches
only work whose prerequisites are satisfied.

## Published review pack

Reviewers should not open `.universal-flow/`. After planning, the workflow mints a
committed pack, by default:

```text
docs/features/<feature-slug>/
├── README.md                      # systems summary
├── technical-spec.md              # full PRD-derived behaviors
├── architecture-overview.md       # end-state models, contracts, diagrams
├── sequence.md                    # PR order and dependency DAG
└── prs/
    └── <nn>-<domain>-<purpose>.md # this PR's slice, with pseudo-code or nominal flow
```

Each PR note links to facets of the architecture overview. Keep `.universal-flow/` in
the target repository `.gitignore`; copy [templates/gitignore](templates/gitignore) if
needed.

## Run artifacts

Each run writes recovery evidence under the target repository. Gitignore this tree:

```text
.universal-flow/runs/<run-id>/
├── run.md
├── artifact-index.md
├── prd-reviews/<feature-slug>.md
├── discovery/
├── requirements/<feature-slug>.md
├── guidance/<packet-id>.md
├── architecture/
├── decisions/
├── human-reviews/
├── realignments/
├── pull-requests/
└── reports/<feature-slug>-final.md
```

`run.md` records status, phase, constraints, decisions, and blockers.
`artifact-index.md` links published files and run evidence. Preserve superseded
decisions instead of silently overwriting them; recovery must not depend on replaying
chat text.

Artifacts and narration lead with readable names and plain-language purpose. Internal IDs
and versions remain index metadata for exact traceability. For example:

- Before: `F-002 invalidates ART-007 v3; approve D-F1-R2.`
- After: `Hosted order events (F-002) changed the runtime assumption. The Order service
  topology draft can no longer be trusted and needs architecture review again.`

Readable filenames use stable purpose slugs, such as
`docs/features/hosted-order-events/technical-spec.md` and
`docs/features/hosted-order-events/prs/02-backend-publish-order-events.md`. Run-folder
names may remain as evidence aliases.

### Architecture documentation

The committed architecture overview is the end-state document people read: simple object
models, contracts, and justified diagrams. Run-scoped `architecture/` files are
versioned evidence only.

If the repository already has architecture or ADR conventions, builders still update
those domain docs in the owning PR. Otherwise they may also write
`docs/architecture/` and `docs/adr/`. Cross-cutting API docs default to the
contract-producing backend PR.

Diagrams appear only when they materially clarify relationships. Proposed diagrams land
in `architecture-overview.md` before requirements approval. The PR DAG lands in
`sequence.md` before sequence approval. Each PR note may add a small nominal flow for
its slice.

## Human approval and realignment

Every run pauses at these approval checkpoints before builds:

1. Requirements approval, after Ponytail accepts the technical requirements.
2. PR sequence approval, after the sequence and PR notes are generated.
3. Per-PR approval, before each PR build. This is on by default (`each-pr: true`);
   set it to `false` in the preset to skip.

At each pause, status is `awaiting-human-review`. The reviewer receives the published
pack first, then exact versions. Universal Flow records the reviewer's
identity, decision, timestamp, comments, and reviewed versions, then resumes
only on explicit approval. Per-PR approval supplements, and never replaces, the
requirements and sequence checkpoints.

Reviewers may edit names, requirements, design, scope, or sequence and request
changes. Invoke `realign-run` with the run ID and review record. It preserves
accepted history, records rename aliases, computes transitive impact, and
supersedes only affected downstream artifacts. Unaffected accepted work stays
valid, and the run returns to the earliest impacted approval checkpoint.

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

The orchestrator creates a small guidance manifest for each implementation packet.
It records applicable `AGENTS.md`, `.cursor/rules/`, and `.agents/skills/` paths,
reasons, statuses, and content hashes without copying their contents. Workers read
the exact manifest before editing and record guidance used or explicitly skipped in
the build report. Repository instructions override generic workflow examples when
they do not violate a run's explicit safety gates.
