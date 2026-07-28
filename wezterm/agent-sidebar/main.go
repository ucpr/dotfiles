// Command agent-sidebar renders a live, vertical list of every pane running
// an agent (Claude Code, Codex, ...) and its status (working/blocked/done/
// idle). Plain shells with no agent are not shown.
//
// It has no access to WezTerm's Lua user_vars (wezterm cli list does not
// expose them), so it just polls the snapshot file that wezterm.lua writes
// via write_agent_status_snapshot():
//
//	$HOME/.cache/wezterm/agent-status.txt   (workspace\tstatus\tagent_name\ttitle per line)
package main

import (
	"encoding/base64"
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"strings"
	"time"

	"github.com/charmbracelet/bubbles/spinner"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

type entry struct {
	workspace string
	status    string
	agentName string
	title     string
}

type tickMsg time.Time

var (
	titleStyle     = lipgloss.NewStyle().Bold(true).Foreground(lipgloss.Color("15")).Padding(0, 1)
	wsStyle        = lipgloss.NewStyle().Bold(true).Foreground(lipgloss.Color("214"))
	dimStyle       = lipgloss.NewStyle().Foreground(lipgloss.Color("240"))
	agentNameStyle = lipgloss.NewStyle().Bold(true).Foreground(lipgloss.Color("111"))

	// Plain, universally-rendered emoji rather than dingbats/symbols, since
	// emoji already carry their own color and don't need an ANSI style.
	statusIcon = map[string]string{
		"blocked": "🔴",
		"done":    "✅",
		"idle":    "⚪",
	}

	// A rotating clock face, the classic simple emoji spinner.
	clockSpinner = spinner.Spinner{
		Frames: []string{"🕛", "🕐", "🕑", "🕒", "🕓", "🕔", "🕕", "🕖", "🕗", "🕘", "🕙", "🕚"},
		FPS:    time.Second / 4,
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
		parts := strings.SplitN(line, "\t", 4)
		if len(parts) < 4 || parts[0] == "" {
			continue
		}
		entries = append(entries, entry{workspace: parts[0], status: parts[1], agentName: parts[2], title: parts[3]})
	}
	return entries
}

type model struct {
	entries []entry
	width   int
	height  int
	spinner spinner.Model
}

func initialModel() model {
	s := spinner.New()
	s.Spinner = clockSpinner
	return model{entries: loadEntries(), spinner: s}
}

func tickCmd() tea.Cmd {
	return tea.Tick(500*time.Millisecond, func(t time.Time) tea.Msg {
		return tickMsg(t)
	})
}

func (m model) Init() tea.Cmd {
	return tea.Batch(tickCmd(), m.spinner.Tick)
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
	default:
		var cmd tea.Cmd
		m.spinner, cmd = m.spinner.Update(msg)
		return m, cmd
	}
	return m, nil
}

// renderIcon returns the leading icon for a row. "working" uses the live
// spinner instead of a static glyph. Entries with no agent_status are never
// sent by wezterm.lua in the first place (see write_agent_status_snapshot),
// so every status here is one of the known ones.
func (m model) renderIcon(status string) string {
	if status == "working" {
		return m.spinner.View() + " "
	}
	icon, ok := statusIcon[status]
	if !ok {
		return "  "
	}
	return icon + " "
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

	for _, ws := range workspaces {
		b.WriteString(wsStyle.Render(ws))
		b.WriteString("\n")
		for _, e := range byWorkspace[ws] {
			prefix := ""
			if e.agentName != "" {
				prefix = e.agentName + " · "
			}
			maxTitle := width - 4 - len([]rune(prefix))
			if maxTitle < 4 {
				maxTitle = 4
			}

			b.WriteString(" ")
			b.WriteString(m.renderIcon(e.status))
			if prefix != "" {
				b.WriteString(agentNameStyle.Render(e.agentName))
				b.WriteString(dimStyle.Render(" · "))
			}
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
