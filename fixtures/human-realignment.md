# Human realignment

## Starting state

Human-approved requirements v2 feed sequence v1:

- **Customer card API (`REQ-API-1`)** produces `CustomerSummary`.
- **Build customer card backend (`PR-01`)** produces the contract.
- **Show customer card (`PR-02`)** consumes it in the frontend.
- **Improve hosted logging (`PR-03`)** is independent.

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
- create a candidate version and trace impact through Customer card API
- explain that Build customer card backend and Show customer card need review again
- keep Improve hosted logging and its accepted packet/build valid
- rerun requirements planning and pre-build Ponytail for the changed contract, then return
  to the mandatory requirements approval checkpoint
- regenerate and review only the affected sequence nodes and packets after approval
- if affected worktrees exist, propose `keep`, `rebase`, `replace`, or `cancel`; mutate
  nothing until the reviewer approves that action
