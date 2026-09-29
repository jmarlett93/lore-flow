# Herdr adapter

This optional adapter runs Lore Flow Cursor builders in real Herdr panes.
Native Cursor delegation remains the default.

## Prerequisites

- `herdr`
- `jq`
- Cursor Agent CLI (`agent`)
- a running or startable Herdr session

## Adapter contract

1. Create one Herdr workspace and `agents` tab per Lore Flow run.
2. Give the adapter the tab root pane and create one child pane per ready packet.
3. Start one Cursor Agent CLI in each child pane with the packet's worktree and
   selected implementation model.
4. Send the bounded build packet with `herdr agent prompt`.
5. Wait with `herdr agent wait`; treat `blocked` as a recovery event, not success.
6. Keep the Lore Flow run artifacts and Git worktree state as the source of truth.

The helper script uses Herdr's JSON IDs rather than predicting pane or workspace IDs:

```bash
adapters/herdr/lore-flow-herdr.sh workspace \
  --cwd /path/to/repo \
  --label lore-flow

adapters/herdr/lore-flow-herdr.sh worker \
  --pane WORKSPACE_TAB_ROOT_PANE \
  --name build-api \
  --cwd /path/to/worktree \
  --model cursor-grok-4.6-high-fast \
  --prompt-file /path/to/build-packet.md \
  --run-id RUN_ID \
  --packet-id PACKET_ID

adapters/herdr/lore-flow-herdr.sh wait \
  --name build-api \
  --timeout 120000
```

Do not close failed panes or delete failed worktrees during recovery. Herdr is the
visibility and input layer; Lore Flow remains responsible for packets, reviews,
commits, and recovery decisions.
