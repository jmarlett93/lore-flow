# Universal Flow Run Schema

Use human-readable Markdown. JSON-compatible values shown below define required fields,
not a requirement to use JSON.
Apply [human-readable-output.md](human-readable-output.md) to all records and paths.

## Run manifest

Create `.universal-flow/runs/<run-id>/run.md` with:

- `run-id`: unique, filesystem-safe identifier
- `status`: `active`, `awaiting-human-review`, `realigning`, `blocked`, `completed`, or
  `failed`
- `target-repository`: canonical path
- `prd-source`: path or authoritative reference
- `preset`: selected key from `config/presets.json`
- `harness`: resolved adapter or harness name
- `started-at` and `updated-at`: ISO-8601 timestamps
- `current-phase`: workflow phase name
- `constraints`: user and repository constraints
- `decisions`: names and outcomes, with internal IDs as metadata
- `pending-approval`: checkpoint name, reviewer, policy, and exact artifact versions
- `blockers`: names and resolutions, with internal IDs and owners as metadata

Do not store secrets, credentials, or full transcripts.

## Artifact index

Create `artifact-index.md`. Each entry leads with:

- display name
- one-sentence plain-language purpose
- type
- status in plain language

Then record:

- stable internal ID, version, and predecessor version
- readable relative path under the run root
- producing role and phase
- input artifact IDs
- one-sentence summary
- evidence references
- name and path aliases
- timestamp

Architecture draft entries also record domain, target durable path, and whether the
draft is an overview, domain document, or ADR. For each embedded diagram, record purpose,
type, home, source requirement IDs, delivery status, and validation evidence. Record a
justified `none` when no diagram applies. Index every draft version separately; do not
create a standalone diagram index unless repository complexity truly requires one.

Update the index when an artifact changes. Preserve superseded artifacts or clearly record
their replacement; do not silently overwrite material decisions.

An accepted version is immutable. A candidate may coexist with it during review. Record
`superseded-by`, supersession reason, and approving review before marking the prior
version `superseded`.

## Human review records

Create one readable record per review under `human-reviews/`. Record:

- display name, plain-language purpose, stable review ID, and checkpoint ID
- reviewer identity
- decision: `approved`, `changes-requested`, or `rejected`
- ISO-8601 timestamp and comments
- reviewed artifact IDs and exact versions
- policy or preset that required the approval checkpoint
- resulting status, decision IDs, and realignment ID when applicable

The mandatory approval checkpoints are Technical requirements and PR sequence. The latter
includes all build packet versions. Approval applies only to listed versions; explain
plainly why a material new version needs review again. Optional checkpoints use the same
record shape.

## Realignment and traceability

Maintain:

- `aliases.md`: stable ID, old name, new name, direction, reason, review ID, and timestamp
- `invalidations.md`: changed source version, classification, dependency path, impact,
  affected version, proposed action, and disposition
- `realignments/<change-slug>.md`: changed artifacts, transitive impact, minimal rerun,
  preserved artifacts, implementation proposals, approvals, and next checkpoint

Change classification is `rename-only`, `requirement`,
`contract-model-state-behavior-design`, `sequencing`, or `scope`. Impact is `none`,
`label-refresh`, `revalidate`, or `regenerate`. Keep unaffected accepted artifacts
accepted and retain all prior review and decision history.

## Readable artifact layout

Use lowercase purpose slugs:

- `prd-reviews/<feature-slug>.md`
- `discovery/<feature-slug>-<area>.md`
- `requirements/<feature-slug>.md`
- `architecture/<feature-slug>-overview.md`
- `architecture/<feature-slug>-<domain>.md` when relevant
- `decisions/<decision-slug>.md`
- `human-reviews/<action>-<subject-slug>.md`
- `realignments/<change-slug>.md`
- `pull-requests/<sequence>-<domain>-<purpose-slug>-packet.md`
- matching `-build.md` and `-review.md` PR artifacts
- `reports/<feature-slug>-final.md`

Keep shared indexes, aliases, and invalidation records at stable descriptive paths.
Legacy canonical filenames may be index aliases; do not create duplicate files merely
for compatibility.

Architecture files under the run root are versioned evidence and source material.
Durable architecture belongs in the target repository's discovered convention, or
`docs/architecture/` and `docs/adr/` when none exists. The artifact index records the
durable target path and owning PR; it does not treat run drafts as delivery.
Diagrams remain embedded parts of those named architecture artifacts by default.

## Evidence

Evidence references must be reproducible and concise:

- repository-relative file path plus line range or symbol
- command and summarized result, with full output saved only when needed
- test/check name and pass/fail result
- authoritative external reference and access date
- artifact ID for prior accepted analysis

Distinguish `observed`, `inferred`, `assumed`, and `unknown`. An inference names its
supporting observations. An assumption names its validation owner and checkpoint.

## Phase completion

A phase is complete only when its required artifact:

1. exists under the run root,
2. is indexed,
3. records inputs and evidence,
4. states unresolved unknowns or blockers, and
5. has status `accepted` or an explicit authorized exception.
