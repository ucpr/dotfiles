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
	"strconv"
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

type fileChange struct {
	file    string
	agent   string
	added   int
	removed int
}

type tickMsg time.Time

var (
	titleStyle     = lipgloss.NewStyle().Bold(true).Foreground(lipgloss.Color("15")).Padding(0, 1)
	wsStyle        = lipgloss.NewStyle().Bold(true).Foreground(lipgloss.Color("214"))
	dimStyle       = lipgloss.NewStyle().Foreground(lipgloss.Color("240"))
	agentNameStyle = lipgloss.NewStyle().Bold(true).Foreground(lipgloss.Color("111"))
	addStyle       = lipgloss.NewStyle().Foreground(lipgloss.Color("42"))
	removeStyle    = lipgloss.NewStyle().Foreground(lipgloss.Color("196"))

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

func fileChangeLogPath() string {
	if p := os.Getenv("AGENT_SIDEBAR_FILECHANGE_FILE"); p != "" {
		return p
	}
	home, err := os.UserHomeDir()
	if err != nil {
		return ""
	}
	return filepath.Join(home, ".cache", "wezterm", "agent-file-changes.log")
}

// loadFileChanges parses agent-filechange.sh's append-only log (see that
// script for the line format). As with loadEntries, a malformed or short
// line is silently skipped rather than erroring, since the log could be
// mid-write.
func loadFileChanges() []fileChange {
	data, err := os.ReadFile(fileChangeLogPath())
	if err != nil {
		return nil
	}
	var changes []fileChange
	for _, line := range strings.Split(strings.TrimRight(string(data), "\n"), "\n") {
		if line == "" {
			continue
		}
		parts := strings.SplitN(line, "\t", 4)
		if len(parts) < 4 || parts[0] == "" {
			continue
		}
		added, _ := strconv.Atoi(strings.TrimPrefix(parts[2], "+"))
		removed, _ := strconv.Atoi(strings.TrimPrefix(parts[3], "-"))
		changes = append(changes, fileChange{file: parts[0], agent: parts[1], added: added, removed: removed})
	}
	return changes
}

type model struct {
	entries     []entry
	fileChanges []fileChange
	width       int
	height      int
	spinner     spinner.Model
}

func initialModel() model {
	s := spinner.New()
	s.Spinner = clockSpinner
	return model{entries: loadEntries(), fileChanges: loadFileChanges(), spinner: s}
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
		m.fileChanges = loadFileChanges()
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
	agentLines, changeLines := m.sectionHeights()

	var b strings.Builder
	b.WriteString(m.renderAgentSection(width, agentLines))
	b.WriteString(m.renderChangeSection(width, changeLines))
	return b.String()
}

// sectionHeights splits the whole pane height into thirds: the bottom third
// (header included) goes to the file-change stream, and the remaining two
// thirds above it to the agent list. Each result is then reduced by that
// section's own title+rule (2 lines) to get its body-line budget. A height
// of 0 (not yet known, e.g. before the first WindowSizeMsg) means "don't
// truncate" and is returned as 0/0.
func (m model) sectionHeights() (agentLines, changeLines int) {
	if m.height <= 0 {
		return 0, 0
	}
	changeSection := m.height / 3
	agentSection := m.height - changeSection
	return bodyLines(agentSection), bodyLines(changeSection)
}

// bodyLines converts a section's total height (including its title+rule) to
// the number of body lines it has room for.
func bodyLines(sectionHeight int) int {
	lines := sectionHeight - 2
	if lines < 1 {
		lines = 1
	}
	return lines
}

// renderAgentSection renders the "AGENTS" list, stopping once maxLines body
// lines (0 = unlimited) have been written so it doesn't spill into the
// file-change section below it.
func (m model) renderAgentSection(width, maxLines int) string {
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

	// Built as a flat slice (rather than written straight to b) so a tight
	// maxLines can cut it off at exactly that many lines without ever
	// leaving a workspace header dangling with none of its entries below it.
	var lines []string
	var isHeader []bool
	for _, ws := range workspaces {
		lines = append(lines, wsStyle.Render(ws))
		isHeader = append(isHeader, true)
		for _, e := range byWorkspace[ws] {
			prefix := ""
			if e.agentName != "" {
				prefix = e.agentName + " · "
			}
			maxTitle := width - 4 - len([]rune(prefix))
			if maxTitle < 4 {
				maxTitle = 4
			}

			var line strings.Builder
			line.WriteString(" ")
			line.WriteString(m.renderIcon(e.status))
			if prefix != "" {
				line.WriteString(agentNameStyle.Render(e.agentName))
				line.WriteString(dimStyle.Render(" · "))
			}
			line.WriteString(truncate(e.title, maxTitle))
			lines = append(lines, line.String())
			isHeader = append(isHeader, false)
		}
	}
	if maxLines > 0 && len(lines) > maxLines {
		lines = lines[:maxLines]
		isHeader = isHeader[:maxLines]
	}
	for len(lines) > 0 && isHeader[len(lines)-1] {
		lines = lines[:len(lines)-1]
	}
	for _, line := range lines {
		b.WriteString(line)
		b.WriteString("\n")
	}

	return b.String()
}

// renderChangeSection renders the "CHANGES" stream: a tail of the most
// recent file edits, oldest to newest so the latest edit reads at the bottom
// like a scrolling log. Each edit takes two lines (agent name, then file +
// diff stat), so maxLines (0 = unlimited) is halved to get the entry count.
func (m model) renderChangeSection(width, maxLines int) string {
	var b strings.Builder
	b.WriteString(titleStyle.Render("CHANGES"))
	b.WriteString("\n")
	b.WriteString(dimStyle.Render(strings.Repeat("─", width)))
	b.WriteString("\n")

	if len(m.fileChanges) == 0 {
		b.WriteString(dimStyle.Render("(no changes yet)"))
		b.WriteString("\n")
		return b.String()
	}

	changes := m.fileChanges
	if maxLines > 0 {
		maxEntries := maxLines / 2
		if maxEntries < 1 {
			maxEntries = 1
		}
		if len(changes) > maxEntries {
			changes = changes[len(changes)-maxEntries:]
		}
	}

	for _, c := range changes {
		b.WriteString(" ")
		b.WriteString(agentNameStyle.Render(c.agent))
		b.WriteString("\n")

		stat := fmt.Sprintf("+%d -%d", c.added, c.removed)
		maxFile := width - 5 - len([]rune(stat))
		if maxFile < 4 {
			maxFile = 4
		}

		b.WriteString("   ")
		b.WriteString(truncate(c.file, maxFile))
		b.WriteString(" ")
		b.WriteString(addStyle.Render(fmt.Sprintf("+%d", c.added)))
		b.WriteString(" ")
		b.WriteString(removeStyle.Render(fmt.Sprintf("-%d", c.removed)))
		b.WriteString("\n")
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
	if len(os.Args) > 1 && os.Args[1] == "setup" {
		runSetup()
		return
	}

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
