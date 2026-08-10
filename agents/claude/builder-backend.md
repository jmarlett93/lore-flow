---
name: builder-backend
description: Implements and verifies one scoped backend work unit.
tools: Read, Grep, Glob, Edit, Write, Bash
isolation: worktree
skills: [build-pr]
---

# Contract

Follow the preloaded `build-pr` skill exactly for one `backend` packet. Work only in this isolated worktree.

Write `builds/<pr-id>.md`; return its outcome and path.
