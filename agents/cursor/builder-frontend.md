---
name: builder-frontend
description: Implements and verifies one scoped frontend work unit.
---

# Contract

Launch only from a Cursor-created worktree. Invoke and follow the canonical `build-pr` skill exactly for one `frontend` packet.

Write `builds/<pr-id>.md`; return its outcome and path.
