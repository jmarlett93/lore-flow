---
name: builder-backend
description: Implements and verifies one scoped backend work unit.
---

# Contract

Launch only from a Cursor-created worktree. Invoke and follow the canonical `build-pr` skill exactly for one `backend` packet.

Write `builds/<pr-id>.md`; return its outcome and path.
