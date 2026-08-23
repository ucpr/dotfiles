# agent-sidebar

A small Go/Bubble Tea TUI, meant to run inside a dedicated narrow WezTerm pane, that renders a live list of every pane running a coding agent (Claude Code, Codex) alongside its status (`working` / `blocked` / `done` / `idle`), a stream of recent file edits, and a stream of completed long-running commands run via `noti`. Clicking any entry in any section focuses that entry's originating pane.

It has a second mode, `agent-sidebar setup`, that wires the hook plumbing into Claude Code's and Codex's config so they report status in the first place.

## How it fits together

`agent-sidebar` is one part of a larger pipeline that spans the parent `wezterm/` directory. There is no direct IPC between this program and WezTerm — a snapshot file on disk is the only interface.

```
Claude Code / Codex hook
        │  (agent_status, agent_name via OSC 1337 SetUserVar)
        ▼
../scripts/agent-status.sh <status> <agent-name>
        │  resolves the pane's tty via `wezterm cli list --format json` + jq,
        │  since hook subprocesses have no controlling terminal
        ▼
../wezterm.lua  write_agent_status_snapshot()
        │  reads every pane's user vars across all workspaces, writes
        │  $HOME/.cache/wezterm/agent-status.txt
        │  (workspace\tstatus\tagent_name\ttitle\tpane_id, one line per pane)
        ▼
agent-sidebar (this program)
        polls the snapshot file every 500ms and renders it, grouped by workspace
```

A second, independent stream feeds the "AGENT CHANGES" section:

```
Claude Code / Codex PostToolUse hook
        ▼
../scripts/agent-filechange.sh <agent-name>
        │  reads the hook JSON payload from stdin, and for Edit/Write tool
        │  calls appends a line to the file-change log
        ▼
$HOME/.cache/wezterm/agent-file-changes.log
        (file\tagent\t+added\t-removed\tpane_id, append-only, trimmed to 500 lines)
        ▼
agent-sidebar (this program)
        polls the log alongside the status snapshot
```

A third, independent stream feeds the "NOTIFY" section:

```
noti <command> [args...]           (shell function, ../../zsh/plugins/func_lazy.zsh)
        │  runs <command> to completion, timing it and capturing its exit code
        ▼
$HOME/.cache/wezterm/agent-notify.log
        (label\texit_code\tduration\tpane_id, append-only, trimmed to 200 lines)
        ▼
agent-sidebar (this program)
        polls the log alongside the status snapshot and file-change log
```

`noti` is a plain interactive-shell wrapper, not a Claude Code/Codex hook - it's meant for wrapping any long-running command (`noti make build`, `noti go test ./...`) so its completion shows up in the sidebar (and as a macOS notification) instead of requiring you to keep checking a terminal you've switched away from. Its exit code is passed through, so `noti <cmd> && next-step` still works.

NOTIFY entries show a `(tab:N)` suffix the same way AGENTS entries do, resolved from a fourth stream:

```
../wezterm.lua  write_agent_status_snapshot()
        │  writes every pane's tab_number - not just agent panes, since a
        │  `noti`-run pane has no agent_status of its own to filter on
        ▼
$HOME/.cache/wezterm/pane-tabs.txt
        (pane_id\ttab_number, one line per pane, rewritten in full every tick)
        ▼
agent-sidebar (this program)
        looks up each NOTIFY entry's pane_id here at render time
```

Because the snapshot/log formats are just tab-separated text files, and `agent-sidebar` itself never talks to WezTerm's Lua user vars (`wezterm cli list` doesn't expose them), any change to any of these wire formats must be kept in sync by hand between this program and whichever of `../wezterm.lua`, the two scripts, or `noti` produces it.

## Usage

Launched from WezTerm as a narrow split pane bound to `Alt-a` (see `../wezterm.lua`), which toggles the sidebar open/closed. It can also be run directly:

```sh
go run .
```

Keys: `q`, `ctrl+c`, or `esc` to quit.

### Setup

Run once per machine to register the hooks that make Claude Code and Codex report their status:

```sh
go run . setup
```

This merges hook entries into Claude Code's `settings.json` and Codex's `hooks.json`, preserving any existing unrelated configuration. It is safe to re-run — it checks for an exact command match before appending, so it never duplicates an entry.

`$CLAUDE_CONFIG_DIR` and `$CODEX_HOME` are honored when set, instead of assuming `~/.claude` / `~/.codex`.

After running `setup`:
- Codex requires an interactive trust step: start `codex`, and when it warns that hooks need review, run `/hooks` and trust them.
- Existing Claude Code sessions need to be restarted to pick up the new hook config.

## Environment variables

| Variable | Purpose | Default |
| --- | --- | --- |
| `AGENT_SIDEBAR_STATE_FILE` | Path to the agent-status snapshot file | `$HOME/.cache/wezterm/agent-status.txt` |
| `AGENT_SIDEBAR_FILECHANGE_FILE` | Path to the file-change log | `$HOME/.cache/wezterm/agent-file-changes.log` |
| `AGENT_SIDEBAR_NOTIFY_FILE` | Path to the `noti` completion log | `$HOME/.cache/wezterm/agent-notify.log` |
| `AGENT_SIDEBAR_PANE_TABS_FILE` | Path to the pane_id → tab_number snapshot | `$HOME/.cache/wezterm/pane-tabs.txt` |
| `CLAUDE_CONFIG_DIR` | Overrides Claude Code's config directory (used by `setup`) | `$HOME/.claude` |
| `CODEX_HOME` | Overrides Codex's config directory (used by `setup`) | `$HOME/.codex` |

## Development

```sh
go build .                                    # build the binary
go test ./...                                 # run all tests
go test -run TestEnsureHooksIsIdempotent .    # run a single test
go vet ./...
```

There's no separate lint config; `go vet` is the extent of it.

## Code layout

- **`main.go`** — the TUI (`model`/`Update`/`View` per Bubble Tea's Elm architecture). Polls the status snapshot, file-change log, `noti` completion log, and pane-tabs snapshot every 500ms and renders three sections: `AGENTS` (grouped by workspace, with a live spinner for `working` and static emoji for other statuses), `AGENT CHANGES` (a tail of recent file edits), and `NOTIFY` (a tail of completed `noti`-wrapped commands, ✅/❌ by exit code, with a `(tab:N)` suffix looked up from the pane-tabs snapshot).
- **`setup.go`** — `agent-sidebar setup`, merging hook entries into Claude Code's and Codex's config files.
- **`setup_test.go`** — covers `ensureHooks` from-scratch creation, idempotency, preservation of pre-existing unrelated config, and the `$CLAUDE_CONFIG_DIR` / `$CODEX_HOME` overrides.

See `CLAUDE.md` for more detail on conventions to preserve when editing this code.
