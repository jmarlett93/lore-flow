#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat >&2 <<'EOF'
Usage:
  lore-flow-herdr.sh workspace --cwd DIR --label LABEL
  lore-flow-herdr.sh worker --pane PANE_ID --name NAME --cwd DIR --model MODEL \
    --prompt-file FILE [--run-id ID] [--packet-id ID]
  lore-flow-herdr.sh wait --name NAME [--timeout MS]
EOF
  exit 2
}

require_command() {
  command -v "$1" >/dev/null || {
    printf 'Required command not found: %s\n' "$1" >&2
    exit 1
  }
}

require_command herdr
require_command jq

command_name="${1:-}"
shift || true

case "$command_name" in
  workspace)
    cwd=
    label=
    while (($#)); do
      case "$1" in
        --cwd) cwd="${2:?missing value for --cwd}"; shift 2 ;;
        --label) label="${2:?missing value for --label}"; shift 2 ;;
        *) usage ;;
      esac
    done
    [[ -n "$cwd" && -n "$label" ]] || usage

    workspace_json="$(herdr workspace create --cwd "$cwd" --label "$label" --no-focus)"
    workspace_id="$(jq -r '.result.workspace.workspace_id // .result.workspace.id' <<<"$workspace_json")"
    tab_json="$(herdr tab create --workspace "$workspace_id" --label agents --cwd "$cwd" --no-focus)"
    jq -n \
      --arg workspace_id "$workspace_id" \
      --arg tab_id "$(jq -r '.result.tab.tab_id // .result.tab.id' <<<"$tab_json")" \
      --arg pane_id "$(jq -r '.result.root_pane.pane_id' <<<"$tab_json")" \
      '{workspace_id, tab_id, pane_id}'
    ;;

  worker)
    pane=
    name=
    cwd=
    model=
    prompt_file=
    run_id=
    packet_id=
    while (($#)); do
      case "$1" in
        --pane) pane="${2:?missing value for --pane}"; shift 2 ;;
        --name) name="${2:?missing value for --name}"; shift 2 ;;
        --cwd) cwd="${2:?missing value for --cwd}"; shift 2 ;;
        --model) model="${2:?missing value for --model}"; shift 2 ;;
        --prompt-file) prompt_file="${2:?missing value for --prompt-file}"; shift 2 ;;
        --run-id) run_id="${2:?missing value for --run-id}"; shift 2 ;;
        --packet-id) packet_id="${2:?missing value for --packet-id}"; shift 2 ;;
        *) usage ;;
      esac
    done
    [[ -n "$pane" && -n "$name" && -n "$cwd" && -n "$model" && -f "$prompt_file" ]] || usage

    split_json="$(herdr pane split --pane "$pane" --direction right --cwd "$cwd" --no-focus)"
    worker_pane="$(jq -r '.result.pane.pane_id' <<<"$split_json")"
    herdr agent start "$name" --kind cursor --pane "$worker_pane" -- --model "$model"
    prompt="$(<"$prompt_file")"
    herdr agent prompt "$name" "$prompt"
    if [[ -n "$run_id" && -n "$packet_id" ]]; then
      herdr pane report-metadata "$worker_pane" \
        --token "summary=$run_id/$packet_id"
    fi
    jq -n \
      --arg name "$name" \
      --arg pane_id "$worker_pane" \
      --arg model "$model" \
      --arg run_id "$run_id" \
      --arg packet_id "$packet_id" \
      '{name, pane_id, model, run_id, packet_id}'
    ;;

  wait)
    name=
    timeout=
    while (($#)); do
      case "$1" in
        --name) name="${2:?missing value for --name}"; shift 2 ;;
        --timeout) timeout="${2:?missing value for --timeout}"; shift 2 ;;
        *) usage ;;
      esac
    done
    [[ -n "$name" ]] || usage
    if [[ -n "$timeout" ]]; then
      herdr agent wait "$name" --until idle --until done --until blocked --timeout "$timeout"
    else
      herdr agent wait "$name" --until idle --until done --until blocked
    fi
    ;;

  *)
    usage
    ;;
esac
