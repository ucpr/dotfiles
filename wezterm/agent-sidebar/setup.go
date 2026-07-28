// `agent-sidebar setup` wires agent-status.sh into Claude Code's and Codex's
// hook configuration so they report status to the sidebar. It merges into
// whatever is already there instead of overwriting the file, and is safe to
// run repeatedly (it won't add a duplicate entry for a command that's
// already present).
package main

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
)

const hookScriptPath = "$HOME/.ghq/github.com/ucpr/dotfiles/wezterm/scripts/agent-status.sh"

type hookSpec struct {
	event  string
	status string
}

// Claude Code and Codex share the same hook event names and hooks.json/
// settings.json shape (Codex can even import Claude's config), so one spec
// list and one merge function cover both.
var hookSpecs = []hookSpec{
	{"UserPromptSubmit", "working"},
	{"PermissionRequest", "blocked"},
	{"PostToolUse", "working"},
	{"Stop", "done"},
	{"SessionEnd", "idle"},
}

func hookCommand(status, agentName string) string {
	return fmt.Sprintf("%s %s %q", hookScriptPath, status, agentName)
}

func runSetup() {
	home, err := os.UserHomeDir()
	if err != nil {
		fmt.Fprintln(os.Stderr, "setup: could not determine home directory:", err)
		os.Exit(1)
	}

	targets := []struct {
		path      string
		agentName string
		label     string
	}{
		{filepath.Join(home, ".claude", "settings.json"), "Claude Code", "Claude Code (~/.claude/settings.json)"},
		{filepath.Join(home, ".codex", "hooks.json"), "Codex", "Codex (~/.codex/hooks.json)"},
	}

	failed := false
	for _, t := range targets {
		changed, err := ensureHooks(t.path, t.agentName)
		if err != nil {
			fmt.Fprintf(os.Stderr, "✗ %s: %v\n", t.label, err)
			failed = true
			continue
		}
		if changed {
			fmt.Printf("✅ %s: hooks added\n", t.label)
		} else {
			fmt.Printf("· %s: already up to date\n", t.label)
		}
	}

	fmt.Println()
	fmt.Println("Codex requires an interactive trust step before hooks run: start `codex`,")
	fmt.Println("and when it warns that hooks need review, run `/hooks` and trust them.")
	fmt.Println("Claude Code sessions started before this setup ran need to be restarted")
	fmt.Println("to pick up the new hook config.")

	if failed {
		os.Exit(1)
	}
}

// ensureHooks merges agent-status.sh into path's "hooks" section for every
// event in hookSpecs, preserving any other content already in the file.
func ensureHooks(path, agentName string) (changed bool, err error) {
	root := map[string]interface{}{}
	data, err := os.ReadFile(path)
	switch {
	case err == nil:
		if err := json.Unmarshal(data, &root); err != nil {
			return false, fmt.Errorf("parsing existing file: %w", err)
		}
	case os.IsNotExist(err):
		// starting from an empty config is fine
	default:
		return false, err
	}

	hooks, _ := root["hooks"].(map[string]interface{})
	if hooks == nil {
		hooks = map[string]interface{}{}
	}

	for _, spec := range hookSpecs {
		cmd := hookCommand(spec.status, agentName)
		eventGroups, _ := hooks[spec.event].([]interface{})

		if hookCommandPresent(eventGroups, cmd) {
			continue
		}
		changed = true
		eventGroups = append(eventGroups, map[string]interface{}{
			"hooks": []interface{}{
				map[string]interface{}{
					"type":    "command",
					"command": cmd,
				},
			},
		})
		hooks[spec.event] = eventGroups
	}

	if !changed {
		return false, nil
	}
	root["hooks"] = hooks

	if err := os.MkdirAll(filepath.Dir(path), 0o755); err != nil {
		return false, err
	}
	out, err := json.MarshalIndent(root, "", "  ")
	if err != nil {
		return false, err
	}
	out = append(out, '\n')
	return true, os.WriteFile(path, out, 0o644)
}

// hookCommandPresent reports whether cmd already appears anywhere in an
// event's hook group list, so setup can be re-run without duplicating it.
func hookCommandPresent(eventGroups []interface{}, cmd string) bool {
	for _, groupRaw := range eventGroups {
		group, ok := groupRaw.(map[string]interface{})
		if !ok {
			continue
		}
		innerHooks, ok := group["hooks"].([]interface{})
		if !ok {
			continue
		}
		for _, hRaw := range innerHooks {
			h, ok := hRaw.(map[string]interface{})
			if !ok {
				continue
			}
			if c, _ := h["command"].(string); c == cmd {
				return true
			}
		}
	}
	return false
}
