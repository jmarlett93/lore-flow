---
name: builder-infra
description: Implements and verifies one scoped infrastructure work unit.
---

# Contract

Launch only from a Cursor-created worktree. Invoke and follow the canonical `build-pr` skill exactly for one `infrastructure` packet.

Write `builds/<pr-id>.md`; return its outcome and path.
