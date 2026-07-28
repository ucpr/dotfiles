#!/bin/sh
# usage: agent-status.sh <status> <agent-name>
# status: working | blocked | done | idle
#
# Hook subprocesses (Claude Code / Codex CLI) have no controlling terminal,
# so /dev/tty cannot be used. Instead resolve the concrete pty device path
# for $WEZTERM_PANE via `wezterm cli list` and write the OSC escape directly
# to that device file.

STATUS="${1:-unknown}"
AGENT_NAME="${2:-unknown}"

TTY_PATH=$(wezterm cli list --format json 2>/dev/null | jq -r --arg pane "$WEZTERM_PANE" '.[] | select((.pane_id|tostring)==$pane) | .tty_name' 2>/dev/null)

if [ -z "$TTY_PATH" ]; then
  exit 0
fi

set_user_var() {
  name="$1"
  value="$2"
  b64=$(printf '%s' "$value" | base64 | tr -d '\n')
  printf '\033]1337;SetUserVar=%s=%s\007' "$name" "$b64" > "$TTY_PATH" 2>/dev/null
}

set_user_var agent_status "$STATUS"
set_user_var agent_name "$AGENT_NAME"
