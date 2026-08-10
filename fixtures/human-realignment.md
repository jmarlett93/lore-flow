# Human realignment

## Starting state

Human-approved requirements v2 feed sequence v1:

- `REQ-API-1` produces `CustomerSummary`
- `PR-01` builds the backend contract
- `PR-02` consumes it in the frontend
- independent `PR-03` updates hosted logging

No build starts until sequence v1 is explicitly approved.

## Rename-only review change

Reviewer `sam@example.com` requests `CustomerSummary` → `CustomerCard` without changing
fields, behavior, or acceptance.

Expected realignment:

- classify `rename-only`
- add alias `CustomerSummary` → `CustomerCard`, retaining stable IDs and reverse trace
- refresh labels in requirements, sequence, and affected packets
- preserve accepted design and all builds; do not rerun discovery or Ponytail
- request approval of the relabeled sequence version before build

## Contract/design review change

The reviewer then requires `CustomerCard.status` to use
`active | suspended | closed` instead of a boolean `enabled`.

Expected realignment:

- classify `contract-model-state-behavior-design`
- preserve requirements v2, sequence v1, and both review records in history
- create a candidate requirements version and impact paths through `REQ-API-1`
- invalidate only `PR-01`, dependent `PR-02`, and their packets/builds
- keep independent `PR-03` and its accepted packet/build valid
- rerun requirements planning and pre-build Ponytail for the changed contract, then return
  to the mandatory requirements gate
- regenerate and review only the affected sequence nodes and packets after approval
- if affected worktrees exist, propose `keep`, `rebase`, `replace`, or `cancel`; mutate
  nothing until the reviewer approves that action
