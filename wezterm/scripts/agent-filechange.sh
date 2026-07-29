#!/bin/sh
# usage: agent-filechange.sh <agent-name>
# PostToolUse hook: reads the hook JSON payload from stdin and, for file-edit
# tool calls, appends one "<file>\t<agent-name>\t+<added>\t-<removed>\t<pane_id>"
# line per changed file to the file-change stream log that agent-sidebar
# tails. pane_id lets the sidebar focus the originating pane on click, same
# as agent-status.sh.
#
# Claude Code (Edit/Write) and Codex (apply_patch) report file edits in
# incompatible shapes, verified by dumping real PostToolUse payloads for both:
#   - Edit/Write: tool_response.structuredPatch already carries unified-diff
#     hunks, so line counts come straight from counting "+"/"-" prefixes
#     there instead of invoking git or diffing the strings ourselves.
#   - apply_patch: tool_response is just a plain "Success. Updated the
#     following files: ..." string with no diff data. The actual edit is a
#     V4A patch in tool_input.command ("*** Begin Patch" / "*** Add File: "
#     or "*** Update File: " / +/-/space lines / "*** End Patch"), which we
#     parse ourselves; a single command can touch multiple files.

AGENT_NAME="${1:-unknown}"
LOG="$HOME/.cache/wezterm/agent-file-changes.log"
MAX_LINES=500

mkdir -p "$(dirname "$LOG")"

payload=$(cat)

tool_name=$(printf '%s' "$payload" | jq -r '.tool_name')
case "$tool_name" in
  Edit|Write)
    file_path=$(printf '%s' "$payload" | jq -r '.tool_input.file_path // empty')
    [ -z "$file_path" ] && exit 0

    added=$(printf '%s' "$payload" | jq -r '[.tool_response.structuredPatch[]?.lines[]? | select(startswith("+"))] | length')
    removed=$(printf '%s' "$payload" | jq -r '[.tool_response.structuredPatch[]?.lines[]? | select(startswith("-"))] | length')

    # A brand-new file (Write with no prior content) has no structuredPatch
    # hunks to diff against, so report every line of it as added instead of
    # +0 -0.
    if [ "$tool_name" = "Write" ] && [ "$added" = "0" ] && [ "$removed" = "0" ]; then
      added=$(printf '%s' "$payload" | jq -r '(.tool_input.content // "") | rtrimstr("\n") | split("\n") | length')
    fi

    printf '%s\t%s\t+%s\t-%s\t%s\n' "$(basename "$file_path")" "$AGENT_NAME" "$added" "$removed" "${WEZTERM_PANE:-}" >> "$LOG"
    ;;
  apply_patch)
    patch_text=$(printf '%s' "$payload" | jq -r '.tool_input.command // empty')
    [ -z "$patch_text" ] && exit 0

    printf '%s' "$patch_text" | awk -v agent="$AGENT_NAME" -v paneid="${WEZTERM_PANE:-}" '
      function flush() {
        if (file != "") {
          printf "%s\t%s\t+%d\t-%d\t%s\n", file, agent, added, removed, paneid
        }
      }
      BEGIN { file = ""; added = 0; removed = 0 }
      /^\*\*\* (Add|Update|Delete) File: / {
        flush()
        file = $0
        sub(/^\*\*\* (Add|Update|Delete) File: /, "", file)
        n = split(file, parts, "/")
        file = parts[n]
        added = 0
        removed = 0
        next
      }
      /^\*\*\* End Patch/ { flush(); file = ""; next }
      /^\*\*\* / { next }
      {
        if (file == "") next
        c = substr($0, 1, 1)
        if (c == "+") added++
        else if (c == "-") removed++
      }
      END { flush() }
    ' >> "$LOG"
    ;;
  *) exit 0 ;;
esac

# Trim the log so a long session doesn't grow it unbounded.
if [ "$(wc -l < "$LOG")" -gt "$MAX_LINES" ]; then
  tail -n "$MAX_LINES" "$LOG" > "$LOG.tmp" && mv "$LOG.tmp" "$LOG"
fi
