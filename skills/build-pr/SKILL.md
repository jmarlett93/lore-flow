---
name: build-pr
description: Implements one sequenced Universal Flow pull request in an isolated git worktree, verifies its named requirements, and emits an evidence-backed build report. Use for each approved PR build packet.
---

# Build PR

Implement exactly one build packet in a dedicated git worktree. Isolate side effects and
preserve strict frontend, backend, or infrastructure scope.

## Inputs

- target repository path
- run root and build packet path
- PR ID, base ref, branch intent, and worktree location policy
- accepted requirement and review artifact paths with exact versions
- human sequence review approving this exact packet and its input versions

Reject a packet that lacks named requirements, acceptance checks, area, dependencies,
architecture-document assignments/exclusions, or output path. Before any mutation,
reject a packet or input that is draft, invalidated, replaced, superseded, or different
from the versions in the approving human review. Do not infer missing scope or approval
from conversation history.

## Worktree safety

1. Inspect repository and worktree state before mutation.
2. Verify prerequisite PRs or refs are present at the expected base.
3. Create or use the dedicated worktree and branch assigned to this PR.
4. Never edit the primary checkout or another PR's worktree.
5. Do not discard, overwrite, stage, commit, or publish unrelated user changes.
6. Do not commit or push unless the invoking workflow explicitly authorizes it.

## Build process

1. Read the bounded packet and referenced artifact sections.
2. Inspect relevant repository conventions and closest existing implementation.
3. Plan the minimal diff needed for the assigned requirement IDs.
4. Implement while keeping each change traceable to a requirement.
5. Update only the durable architecture documents and ADRs assigned in the packet, using
   the target repository's convention and versioned run drafts as source material.
6. Verify changed documentation links, examples, commands, configuration references, and
   indexes against the implemented repository state.
7. Add or update tests for observable acceptance and meaningful failures.
8. Run the narrowest relevant checks first, then required repository-native checks.
9. Inspect the final diff for area leakage, unassigned architecture docs, generated
   churn, secrets, and unrelated edits.
10. Write the build report; do not claim checks that were not run.

Escalate rather than implement when a change:

- adds a new requirement or product behavior
- crosses into another area
- touches an architecture document or ADR not explicitly assigned to this packet
- contradicts an accepted contract
- requires an unapproved migration or net-new resource
- depends on unavailable credentials, services, or user decisions

For a frontend-leading approved no-op, preserve the packet's exact note in the build
report and do not fabricate an endpoint. Infrastructure changes must implement and verify
both local and hosted configuration obligations.

## Output contract

Write `builds/<pr-id>.md`:

```markdown
# Build Report: [PR ID]
Outcome: ready-for-review | blocked | failed

## Worktree and base
## Requirements implemented
## Change summary
## Files changed
## Contract impact
## Durable architecture documentation
- Assigned docs/ADRs updated:
- Draft versions used:
- Links/examples/config references verified:
- Assigned documentation not updated:
## Local and hosted configuration
## Tests and checks
- [command/check]: pass | fail | not-run — [evidence/reason]
## Diff reference
## Deviations and decisions
## Risks and follow-up
## Blockers
```

Evidence must include repository-relative files and symbols, summarized check results,
and the diff ref or patch location needed by post-build Ponytail review.

## Completion

Return only outcome, requirement coverage, changed-file summary, check summary, blockers,
and build-report path. Leave the worktree intact for adversarial review and remediation.
Do not forward command logs or an implementation transcript.
