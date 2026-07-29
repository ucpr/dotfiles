// Command agent-sidebar renders a live, vertical list of every pane running
// an agent (Claude Code, Codex, ...) and its status (working/blocked/done/
// idle). Plain shells with no agent are not shown.
//
// It has no access to WezTerm's Lua user_vars (wezterm cli list does not
// expose them), so it just polls the snapshot file that wezterm.lua writes
// via write_agent_status_snapshot():
//
//	$HOME/.cache/wezterm/agent-status.txt   (workspace\tstatus\tagent_name\ttitle\tpane_id per line)
package main

import (
	"encoding/base64"
	"fmt"
	"os"
	"os/exec"
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
	paneID    string
}

type fileChange struct {
	file    string
	agent   string
	added   int
	removed int
	paneID  string
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
		// pane_id is split off the end (rather than via one big SplitN) so a
		// title that happens to contain a literal tab still parses correctly;
		// pane_id itself is always a plain number with no tab in it.
		titleAndPaneID := parts[3]
		idx := strings.LastIndex(titleAndPaneID, "\t")
		if idx < 0 {
			continue
		}
		title, paneID := titleAndPaneID[:idx], titleAndPaneID[idx+1:]
		entries = append(entries, entry{workspace: parts[0], status: parts[1], agentName: parts[2], title: title, paneID: paneID})
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
		parts := strings.SplitN(line, "\t", 5)
		if len(parts) < 5 || parts[0] == "" {
			continue
		}
		added, _ := strconv.Atoi(strings.TrimPrefix(parts[2], "+"))
		removed, _ := strconv.Atoi(strings.TrimPrefix(parts[3], "-"))
		changes = append(changes, fileChange{file: parts[0], agent: parts[1], added: added, removed: removed, paneID: parts[4]})
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
	case tea.MouseMsg:
		if msg.Action == tea.MouseActionPress && msg.Button == tea.MouseButtonLeft {
			if paneID := m.paneIDAtRow(msg.Y); paneID != "" {
				return m, activatePaneCmd(paneID)
			}
		}
		return m, nil
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

// agentUnit is one renderable chunk of the AGENTS body: either a 1-line
// workspace header (paneID "") or a 2-line entry (icon + agent name, then
// title). agentUnits is the single source of truth for this layout so
// rendering and mouse click hit-testing can never drift apart.
type agentUnit struct {
	lines  []string
	paneID string
}

func (m model) agentUnits(width int) []agentUnit {
	byWorkspace := map[string][]entry{}
	var workspaces []string
	for _, e := range m.entries {
		if _, ok := byWorkspace[e.workspace]; !ok {
			workspaces = append(workspaces, e.workspace)
		}
		byWorkspace[e.workspace] = append(byWorkspace[e.workspace], e)
	}
	sort.Strings(workspaces)

	maxTitle := width - 3
	if maxTitle < 4 {
		maxTitle = 4
	}

	var units []agentUnit
	for _, ws := range workspaces {
		units = append(units, agentUnit{lines: []string{wsStyle.Render(ws)}})
		for _, e := range byWorkspace[ws] {
			units = append(units, agentUnit{
				lines: []string{
					" " + m.renderIcon(e.status) + agentNameStyle.Render(e.agentName),
					"   " + truncate(e.title, maxTitle),
				},
				paneID: e.paneID,
			})
		}
	}
	return units
}

// agentSectionLineCount returns how many screen lines the AGENTS section
// actually renders (title+rule, plus body up to maxLines), which can be
// fewer than its budget if there isn't enough data to fill it. The CHANGES
// section below it starts immediately at this row, since View() concatenates
// the two sections with no padding in between.
func (m model) agentSectionLineCount(width, maxLines int) int {
	if len(m.entries) == 0 {
		return 3 // title + rule + "(no agents yet)"
	}
	body := 0
	for _, u := range m.agentUnits(width) {
		if maxLines > 0 && body+len(u.lines) > maxLines {
			break
		}
		body += len(u.lines)
	}
	return 2 + body
}

// changeUnit is one renderable chunk of the CHANGES body: a 2-line file edit
// (agent name, then file + diff stat). Mirrors agentUnit so rendering and
// mouse click hit-testing share the same layout.
type changeUnit struct {
	lines  []string
	paneID string
}

func (m model) changeUnits(width int) []changeUnit {
	var units []changeUnit
	for _, c := range m.fileChanges {
		stat := fmt.Sprintf("+%d -%d", c.added, c.removed)
		maxFile := width - 5 - len([]rune(stat))
		if maxFile < 4 {
			maxFile = 4
		}
		units = append(units, changeUnit{
			lines: []string{
				" " + agentNameStyle.Render(c.agent),
				"   " + truncate(c.file, maxFile) + " " +
					addStyle.Render(fmt.Sprintf("+%d", c.added)) + " " +
					removeStyle.Render(fmt.Sprintf("-%d", c.removed)),
			},
			paneID: c.paneID,
		})
	}
	return units
}

// tailChangeUnits keeps only the most recent entries that fit maxLines body
// lines (0 = unlimited), matching the tail-of-the-log behavior of the
// CHANGES stream.
func tailChangeUnits(units []changeUnit, maxLines int) []changeUnit {
	if maxLines <= 0 {
		return units
	}
	maxEntries := maxLines / 2
	if maxEntries < 1 {
		maxEntries = 1
	}
	if len(units) > maxEntries {
		return units[len(units)-maxEntries:]
	}
	return units
}

// paneIDAtRow returns the pane id of the AGENTS or CHANGES entry rendered at
// absolute screen row y (0-indexed from the very top of the view), or "" if
// y falls on a header, a workspace header, or outside any clickable entry.
// Used to resolve mouse clicks to a pane to focus.
func (m model) paneIDAtRow(y int) string {
	width := m.width
	if width <= 0 {
		width = 30
	}
	agentLines, changeLines := m.sectionHeights()

	agentSectionRows := m.agentSectionLineCount(width, agentLines)

	if y >= 2 && y < agentSectionRows {
		bodyRow := y - 2
		line := 0
		for _, u := range m.agentUnits(width) {
			if agentLines > 0 && line+len(u.lines) > agentLines {
				break
			}
			if bodyRow >= line && bodyRow < line+len(u.lines) {
				return u.paneID
			}
			line += len(u.lines)
		}
		return ""
	}

	changeBodyRow := y - agentSectionRows - 2 // 2 header lines: "CHANGES" title + rule
	if changeBodyRow < 0 {
		return ""
	}
	line := 0
	for _, u := range tailChangeUnits(m.changeUnits(width), changeLines) {
		if changeBodyRow >= line && changeBodyRow < line+len(u.lines) {
			return u.paneID
		}
		line += len(u.lines)
	}
	return ""
}

// activatePaneCmd shells out to `wezterm cli activate-pane`, the same CLI
// agent-status.sh already relies on to resolve tty paths, since agent-sidebar
// has no direct IPC to the mux server to focus a pane itself.
func activatePaneCmd(paneID string) tea.Cmd {
	return func() tea.Msg {
		exec.Command("wezterm", "cli", "activate-pane", "--pane-id", paneID).Run()
		return nil
	}
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

	lineCount := 0
	for _, u := range m.agentUnits(width) {
		if maxLines > 0 && lineCount+len(u.lines) > maxLines {
			break
		}
		for _, line := range u.lines {
			b.WriteString(line)
			b.WriteString("\n")
		}
		lineCount += len(u.lines)
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

	for _, u := range tailChangeUnits(m.changeUnits(width), maxLines) {
		for _, line := range u.lines {
			b.WriteString(line)
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
	if len(os.Args) > 1 && os.Args[1] == "setup" {
		runSetup()
		return
	}

	announceSelf()
	// Without the alt screen, bubbletea uses inline rendering, which tracks
	// the previous frame's line count to move the cursor back up before
	// redrawing. A pane resize desyncs that count and corrupts the display.
	// The alt screen gives it a dedicated full-screen buffer instead.
	p := tea.NewProgram(initialModel(), tea.WithAltScreen(), tea.WithMouseCellMotion())
	if _, err := p.Run(); err != nil {
		fmt.Fprintln(os.Stderr, "agent-sidebar:", err)
		os.Exit(1)
	}
}
