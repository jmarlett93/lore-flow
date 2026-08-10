# Universal Flow Run Schema

Use human-readable Markdown. JSON-compatible values shown below define required fields,
not a requirement to use JSON.

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
- `decisions`: decision IDs with short outcomes
- `pending-gate`: gate ID, required reviewer or policy, and exact artifact versions
- `blockers`: blocker IDs, owner, and required resolution

Do not store secrets, credentials, or full transcripts.

## Artifact index

Create `artifact-index.md`. Each row or list entry contains:

- stable artifact ID
- artifact type
- version and predecessor version, when any
- relative path under the run root
- producing role and phase
- status: `draft`, `accepted`, `superseded`, or `blocked`
- input artifact IDs
- one-sentence summary
- evidence references
- timestamp

Architecture draft entries also record domain, target durable path, and whether the
draft is an overview, domain document, or ADR. Index every version separately.

Update the index when an artifact changes. Preserve superseded artifacts or clearly record
their replacement; do not silently overwrite material decisions.

An accepted version is immutable. A candidate may coexist with it during review. Record
`superseded-by`, supersession reason, and approving review before marking the prior
version `superseded`.

## Human review records

Create one durable record per review under `human-reviews/`. Record:

- stable review and gate IDs
- reviewer identity
- decision: `approved`, `changes-requested`, or `rejected`
- ISO-8601 timestamp and comments
- reviewed artifact IDs and exact versions
- policy or preset that required the gate
- resulting status, decision IDs, and realignment ID when applicable

The mandatory gates are `technical-requirements` and `pr-sequence`. The latter includes
all build packet versions. Approval applies only to the listed versions; a material new
version requires a new review. Optional per-PR gates use the same record shape.

## Realignment and traceability

Maintain:

- `aliases.md`: stable ID, old name, new name, direction, reason, review ID, and timestamp
- `invalidations.md`: changed source version, classification, dependency path, impact,
  affected version, proposed action, and disposition
- `realignments/<realignment-id>.md`: changed artifacts, transitive impact, minimal rerun,
  preserved artifacts, implementation proposals, approvals required, and next gate

Change classification is `rename-only`, `requirement`,
`contract-model-state-behavior-design`, `sequencing`, or `scope`. Impact is `none`,
`label-refresh`, `revalidate`, or `regenerate`. Keep unaffected accepted artifacts
accepted and retain all prior review and decision history.

## Canonical artifacts

Use these names unless multiple PRs require a stable suffix:

- `prd-review.md`
- `discovery/frontend.md`
- `discovery/backend.md`
- `discovery/infrastructure.md`
- `discovery-index.md`
- `requirements.md`
- `architecture/overview.md`
- `architecture/frontend.md` when relevant
- `architecture/backend.md` when relevant
- `architecture/infrastructure.md` when relevant
- `architecture/adr/<decision-id>.md` when warranted
- `ponytail-pre-build.md`
- `decision-log.md`
- `human-reviews/<review-id>.md`
- `aliases.md`
- `invalidations.md`
- `realignments/<realignment-id>.md`
- `pr-sequence.md`
- `packets/<pr-id>.md`
- `builds/<pr-id>.md`
- `reviews/<pr-id>-ponytail.md`
- `final-report.md`

Architecture files under the run root are versioned evidence and source material.
Durable architecture belongs in the target repository's discovered convention, or
`docs/architecture/` and `docs/adr/` when none exists. The artifact index records the
durable target path and owning PR; it does not treat run drafts as delivery.

## Evidence

Evidence references must be reproducible and concise:

- repository-relative file path plus line range or symbol
- command and summarized result, with full output saved only when needed
- test/check name and pass/fail result
- authoritative external reference and access date
- artifact ID for prior accepted analysis

Distinguish `observed`, `inferred`, `assumed`, and `unknown`. An inference names its
supporting observations. An assumption names its validation owner and gate.

## Phase completion

A phase is complete only when its required artifact:

1. exists under the run root,
2. is indexed,
3. records inputs and evidence,
4. states unresolved unknowns or blockers, and
5. has status `accepted` or an explicit authorized exception.
