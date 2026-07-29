#!/bin/sh
# usage: agent-filechange.sh <agent-name>
# PostToolUse hook: reads the hook JSON payload from stdin and, for Edit/Write
# tool calls, appends "<file>\t<agent-name>\t+<added>\t-<removed>\t<pane_id>"
# to the file-change stream log that agent-sidebar tails. pane_id lets the
# sidebar focus the originating pane on click, same as agent-status.sh.
#
# tool_response.structuredPatch already carries unified-diff hunks (verified
# by dumping a real PostToolUse payload for both Edit and Write), so line
# counts come straight from counting "+"/"-" prefixes there instead of
# invoking git or diffing the strings ourselves.

AGENT_NAME="${1:-unknown}"
LOG="$HOME/.cache/wezterm/agent-file-changes.log"
MAX_LINES=500

mkdir -p "$(dirname "$LOG")"

payload=$(cat)

tool_name=$(printf '%s' "$payload" | jq -r '.tool_name')
case "$tool_name" in
  Edit|Write) ;;
  *) exit 0 ;;
esac

file_path=$(printf '%s' "$payload" | jq -r '.tool_input.file_path // empty')
[ -z "$file_path" ] && exit 0

added=$(printf '%s' "$payload" | jq -r '[.tool_response.structuredPatch[]?.lines[]? | select(startswith("+"))] | length')
removed=$(printf '%s' "$payload" | jq -r '[.tool_response.structuredPatch[]?.lines[]? | select(startswith("-"))] | length')

# A brand-new file (Write with no prior content) has no structuredPatch hunks
# to diff against, so report every line of it as added instead of +0 -0.
if [ "$tool_name" = "Write" ] && [ "$added" = "0" ] && [ "$removed" = "0" ]; then
  added=$(printf '%s' "$payload" | jq -r '(.tool_input.content // "") | rtrimstr("\n") | split("\n") | length')
fi

# $WEZTERM_PANE is already the pane's id (agent-status.sh matches it against
# `wezterm cli list`'s .pane_id), so it can be used directly with no lookup.
printf '%s\t%s\t+%s\t-%s\t%s\n' "$(basename "$file_path")" "$AGENT_NAME" "$added" "$removed" "${WEZTERM_PANE:-}" >> "$LOG"

# Trim the log so a long session doesn't grow it unbounded.
if [ "$(wc -l < "$LOG")" -gt "$MAX_LINES" ]; then
  tail -n "$MAX_LINES" "$LOG" > "$LOG.tmp" && mv "$LOG.tmp" "$LOG"
fi
