// Command agent-sidebar renders a live, vertical list of every WezTerm
// workspace/tab and its rolled-up agent_status (working/blocked/done/idle).
//
// It has no access to WezTerm's Lua user_vars (wezterm cli list does not
// expose them), so it just polls the snapshot file that wezterm.lua writes
// via write_agent_status_snapshot():
//
//	$HOME/.cache/wezterm/agent-status.txt   (workspace\tstatus\ttitle per line)
package main

import (
	"encoding/base64"
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"strings"
	"time"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

type entry struct {
	workspace string
	status    string
	title     string
}

type tickMsg time.Time

var (
	titleStyle = lipgloss.NewStyle().Bold(true).Foreground(lipgloss.Color("15")).Padding(0, 1)
	wsStyle    = lipgloss.NewStyle().Bold(true).Foreground(lipgloss.Color("214"))
	dimStyle   = lipgloss.NewStyle().Foreground(lipgloss.Color("240"))

	statusColor = map[string]string{
		"blocked": "203",
		"working": "220",
		"done":    "78",
		"idle":    "240",
	}
	statusIcon = map[string]string{
		"blocked": "⛔",
		"working": "⚙",
		"done":    "✔",
		"idle":    "·",
	}
)

func statePath() string {
	if p := os.Getenv("AGENT_SIDEBAR_STATE_FILE"); p != "" {
		return p
	}
	home, err := os.UserHomeDir()
	if err != nil {
		return ""
	}
	return filepath.Join(home, ".cache", "wezterm", "agent-status.txt")
}

func loadEntries() []entry {
	data, err := os.ReadFile(statePath())
	if err != nil {
		return nil
	}
	var entries []entry
	for _, line := range strings.Split(strings.TrimRight(string(data), "\n"), "\n") {
		if line == "" {
			continue
		}
		parts := strings.SplitN(line, "\t", 3)
		if len(parts) < 3 || parts[0] == "" {
			continue
		}
		entries = append(entries, entry{workspace: parts[0], status: parts[1], title: parts[2]})
	}
	return entries
}

type model struct {
	entries []entry
	width   int
	height  int
}

func initialModel() model {
	return model{entries: loadEntries()}
}

func tickCmd() tea.Cmd {
	return tea.Tick(500*time.Millisecond, func(t time.Time) tea.Msg {
		return tickMsg(t)
	})
}

func (m model) Init() tea.Cmd {
	return tickCmd()
}

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.WindowSizeMsg:
		m.width = msg.Width
		m.height = msg.Height
		return m, nil
	case tea.KeyMsg:
		switch msg.String() {
		case "q", "ctrl+c", "esc":
			return m, tea.Quit
		}
	case tickMsg:
		m.entries = loadEntries()
		return m, tickCmd()
	}
	return m, nil
}

func renderIcon(status string) string {
	icon, ok := statusIcon[status]
	if !ok {
		return "  "
	}
	color, ok := statusColor[status]
	if !ok {
		color = "255"
	}
	return lipgloss.NewStyle().Foreground(lipgloss.Color(color)).Render(icon) + " "
}

func truncate(s string, max int) string {
	runes := []rune(s)
	if max < 1 || len(runes) <= max {
		return s
	}
	if max == 1 {
		return "…"
	}
	return string(runes[:max-1]) + "…"
}

func (m model) View() string {
	width := m.width
	if width <= 0 {
		width = 30
	}

	var b strings.Builder
	b.WriteString(titleStyle.Render("AGENTS"))
	b.WriteString("\n")
	b.WriteString(dimStyle.Render(strings.Repeat("─", width)))
	b.WriteString("\n")

	if len(m.entries) == 0 {
		b.WriteString(dimStyle.Render("(no agents yet)"))
		b.WriteString("\n")
		return b.String()
	}

	byWorkspace := map[string][]entry{}
	var workspaces []string
	for _, e := range m.entries {
		if _, ok := byWorkspace[e.workspace]; !ok {
			workspaces = append(workspaces, e.workspace)
		}
		byWorkspace[e.workspace] = append(byWorkspace[e.workspace], e)
	}
	sort.Strings(workspaces)

	maxTitle := width - 4
	if maxTitle < 4 {
		maxTitle = 4
	}

	for _, ws := range workspaces {
		b.WriteString(wsStyle.Render(ws))
		b.WriteString("\n")
		for _, e := range byWorkspace[ws] {
			b.WriteString(" ")
			b.WriteString(renderIcon(e.status))
			b.WriteString(truncate(e.title, maxTitle))
			b.WriteString("\n")
		}
	}

	return b.String()
}

// announceSelf marks this pane's agent_status user var as belonging to the
// sidebar itself, so write_agent_status_snapshot() in wezterm.lua can skip
// it and avoid the sidebar listing its own pane.
func announceSelf() {
	b64 := base64.StdEncoding.EncodeToString([]byte("1"))
	fmt.Fprintf(os.Stdout, "\033]1337;SetUserVar=agent_sidebar=%s\007", b64)
}

func main() {
	announceSelf()
	// Without the alt screen, bubbletea uses inline rendering, which tracks
	// the previous frame's line count to move the cursor back up before
	// redrawing. A pane resize desyncs that count and corrupts the display.
	// The alt screen gives it a dedicated full-screen buffer instead.
	p := tea.NewProgram(initialModel(), tea.WithAltScreen())
	if _, err := p.Run(); err != nil {
		fmt.Fprintln(os.Stderr, "agent-sidebar:", err)
		os.Exit(1)
	}
}
