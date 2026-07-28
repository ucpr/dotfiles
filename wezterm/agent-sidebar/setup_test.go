package main

import (
	"encoding/json"
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func readHooks(t *testing.T, path string) map[string]interface{} {
	t.Helper()
	data, err := os.ReadFile(path)
	if err != nil {
		t.Fatalf("reading %s: %v", path, err)
	}
	var root map[string]interface{}
	if err := json.Unmarshal(data, &root); err != nil {
		t.Fatalf("parsing %s: %v\ncontent: %s", path, err, data)
	}
	hooks, ok := root["hooks"].(map[string]interface{})
	if !ok {
		t.Fatalf("no \"hooks\" object in %s: %v", path, root)
	}
	return hooks
}

func eventGroups(t *testing.T, hooks map[string]interface{}, event string) []interface{} {
	t.Helper()
	groups, ok := hooks[event].([]interface{})
	if !ok {
		t.Fatalf("no groups for event %q: %v", event, hooks)
	}
	return groups
}

// countCommand returns how many times cmd appears across an event's groups,
// to check both presence and (for idempotency) that it's not duplicated.
func countCommand(groups []interface{}, cmd string) int {
	count := 0
	for _, groupRaw := range groups {
		group := groupRaw.(map[string]interface{})
		innerHooks := group["hooks"].([]interface{})
		for _, hRaw := range innerHooks {
			h := hRaw.(map[string]interface{})
			if h["command"] == cmd {
				count++
			}
		}
	}
	return count
}

func TestEnsureHooksCreatesFileFromScratch(t *testing.T) {
	path := filepath.Join(t.TempDir(), "settings.json")

	changed, err := ensureHooks(path, "Claude Code")
	if err != nil {
		t.Fatalf("ensureHooks: %v", err)
	}
	if !changed {
		t.Fatal("expected changed=true when creating a new file")
	}

	hooks := readHooks(t, path)
	for _, spec := range hookSpecs {
		groups := eventGroups(t, hooks, spec.event)
		want := hookCommand(spec.status, "Claude Code")
		if got := countCommand(groups, want); got != 1 {
			t.Errorf("event %s: command %q appears %d times, want 1", spec.event, want, got)
		}
	}
}

func TestEnsureHooksIsIdempotent(t *testing.T) {
	path := filepath.Join(t.TempDir(), "settings.json")

	if _, err := ensureHooks(path, "Claude Code"); err != nil {
		t.Fatalf("first ensureHooks: %v", err)
	}
	changed, err := ensureHooks(path, "Claude Code")
	if err != nil {
		t.Fatalf("second ensureHooks: %v", err)
	}
	if changed {
		t.Fatal("expected changed=false on second run with no new hooks to add")
	}

	hooks := readHooks(t, path)
	for _, spec := range hookSpecs {
		groups := eventGroups(t, hooks, spec.event)
		want := hookCommand(spec.status, "Claude Code")
		if got := countCommand(groups, want); got != 1 {
			t.Errorf("event %s: command %q appears %d times after re-running setup, want 1 (no duplicates)", spec.event, want, got)
		}
	}
}

func TestEnsureHooksPreservesExistingContent(t *testing.T) {
	path := filepath.Join(t.TempDir(), "settings.json")

	existing := `{
		"permissions": { "allow": ["Bash(ls)"] },
		"hooks": {
			"UserPromptSubmit": [
				{ "hooks": [{ "type": "command", "command": "echo unrelated-hook" }] }
			]
		}
	}`
	if err := os.WriteFile(path, []byte(existing), 0o644); err != nil {
		t.Fatalf("seeding existing file: %v", err)
	}

	changed, err := ensureHooks(path, "Claude Code")
	if err != nil {
		t.Fatalf("ensureHooks: %v", err)
	}
	if !changed {
		t.Fatal("expected changed=true when adding new hooks to an existing file")
	}

	data, err := os.ReadFile(path)
	if err != nil {
		t.Fatalf("reading result: %v", err)
	}
	var root map[string]interface{}
	if err := json.Unmarshal(data, &root); err != nil {
		t.Fatalf("parsing result: %v", err)
	}

	// The unrelated top-level setting must survive untouched.
	perms, ok := root["permissions"].(map[string]interface{})
	if !ok {
		t.Fatalf("permissions block was lost: %v", root)
	}
	allow, _ := perms["allow"].([]interface{})
	if len(allow) != 1 || allow[0] != "Bash(ls)" {
		t.Errorf("permissions.allow was mutated: %v", allow)
	}

	hooks := root["hooks"].(map[string]interface{})
	// The pre-existing, unrelated UserPromptSubmit hook must still be there...
	groups := eventGroups(t, hooks, "UserPromptSubmit")
	if countCommand(groups, "echo unrelated-hook") != 1 {
		t.Errorf("pre-existing unrelated hook was dropped: %v", groups)
	}
	// ...alongside our new one, not replacing it.
	want := hookCommand("working", "Claude Code")
	if countCommand(groups, want) != 1 {
		t.Errorf("new hook was not appended: %v", groups)
	}
}

func TestClaudeSettingsPathHonorsConfigDirEnvVar(t *testing.T) {
	t.Setenv("CLAUDE_CONFIG_DIR", "")
	if got, want := claudeSettingsPath("/home/u"), filepath.Join("/home/u", ".claude", "settings.json"); got != want {
		t.Errorf("with no CLAUDE_CONFIG_DIR: got %q, want %q", got, want)
	}

	t.Setenv("CLAUDE_CONFIG_DIR", "/custom/claude-dir")
	if got, want := claudeSettingsPath("/home/u"), filepath.Join("/custom/claude-dir", "settings.json"); got != want {
		t.Errorf("with CLAUDE_CONFIG_DIR set: got %q, want %q", got, want)
	}
}

func TestCodexHooksPathHonorsCodexHomeEnvVar(t *testing.T) {
	t.Setenv("CODEX_HOME", "")
	if got, want := codexHooksPath("/home/u"), filepath.Join("/home/u", ".codex", "hooks.json"); got != want {
		t.Errorf("with no CODEX_HOME: got %q, want %q", got, want)
	}

	t.Setenv("CODEX_HOME", "/custom/codex-dir")
	if got, want := codexHooksPath("/home/u"), filepath.Join("/custom/codex-dir", "hooks.json"); got != want {
		t.Errorf("with CODEX_HOME set: got %q, want %q", got, want)
	}
}

func TestHookCommandIncludesStatusAndAgentName(t *testing.T) {
	got := hookCommand("blocked", "Codex")
	if got == "" {
		t.Fatal("hookCommand returned empty string")
	}
	if !strings.Contains(got, "blocked") || !strings.Contains(got, "Codex") || !strings.Contains(got, hookScriptPath) {
		t.Errorf("hookCommand(%q, %q) = %q, missing expected parts", "blocked", "Codex", got)
	}
}
