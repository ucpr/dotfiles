// Command agent-sidebar renders a live, vertical list of every pane running
// an agent (Claude Code, Codex, ...) and its status (working/blocked/done/
// idle). Plain shells with no agent are not shown.
//
// It has no access to WezTerm's Lua user_vars (wezterm cli list does not
// expose them), so it just polls the snapshot file that wezterm.lua writes
// via write_agent_status_snapshot():
//
//	$HOME/.cache/wezterm/agent-status.txt   (workspace\tstatus\tagent_name\ttab_number\ttitle\tpane_id per line)
//
// It also raises a macOS notification (via osascript) whenever a pane
// transitions into a wait state (blocked/done), skipping whichever pane the
// user is currently focused on (per `wezterm cli list-clients`). See
// waitTransitions and focusedPaneID.
package main

import (
	"encoding/base64"
	"encoding/json"
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
	"github.com/charmbracelet/x/ansi"
	"github.com/charmbracelet/x/term"
)

type entry struct {
	workspace string
	status    string
	agentName string
	tabNumber string
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

type notification struct {
	label    string
	exitCode int
	duration string
	paneID   string
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

	// The two statuses that represent an agent waiting on the user (a
	// permission prompt, or a finished turn awaiting the next prompt) and
	// should raise a macOS notification when a pane transitions into them.
	waitStatuses = map[string]bool{"blocked": true, "done": true}
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
		parts := strings.SplitN(line, "\t", 5)
		if len(parts) < 5 || parts[0] == "" {
			continue
		}
		// pane_id is split off the end (rather than via one big SplitN) so a
		// title that happens to contain a literal tab still parses correctly;
		// pane_id itself is always a plain number with no tab in it.
		titleAndPaneID := parts[4]
		idx := strings.LastIndex(titleAndPaneID, "\t")
		if idx < 0 {
			continue
		}
		title, paneID := titleAndPaneID[:idx], titleAndPaneID[idx+1:]
		entries = append(entries, entry{workspace: parts[0], status: parts[1], agentName: parts[2], tabNumber: parts[3], title: title, paneID: paneID})
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

func notifyLogPath() string {
	if p := os.Getenv("AGENT_SIDEBAR_NOTIFY_FILE"); p != "" {
		return p
	}
	home, err := os.UserHomeDir()
	if err != nil {
		return ""
	}
	return filepath.Join(home, ".cache", "wezterm", "agent-notify.log")
}

// loadNotifications parses the `noti` shell function's completion log (see
// zsh/plugins/func_lazy.zsh). Unlike loadEntries/loadFileChanges, the label
// field can't contain a literal tab in the first place - `noti` sanitizes it
// before appending - so a plain 4-way split is enough, no need for the
// split-from-the-end trick those two use for their own tab-safe fields.
func loadNotifications() []notification {
	data, err := os.ReadFile(notifyLogPath())
	if err != nil {
		return nil
	}
	var notifications []notification
	for _, line := range strings.Split(strings.TrimRight(string(data), "\n"), "\n") {
		if line == "" {
			continue
		}
		parts := strings.SplitN(line, "\t", 4)
		if len(parts) < 4 || parts[0] == "" {
			continue
		}
		exitCode, _ := strconv.Atoi(parts[1])
		notifications = append(notifications, notification{label: parts[0], exitCode: exitCode, duration: parts[2], paneID: parts[3]})
	}
	return notifications
}

func paneTabsPath() string {
	if p := os.Getenv("AGENT_SIDEBAR_PANE_TABS_FILE"); p != "" {
		return p
	}
	home, err := os.UserHomeDir()
	if err != nil {
		return ""
	}
	return filepath.Join(home, ".cache", "wezterm", "pane-tabs.txt")
}

// loadPaneTabs parses wezterm.lua's pane_id -> tab_number snapshot, written
// for every pane (not just agent panes) since NOTIFY entries come from
// `noti`, an arbitrary interactive shell command with no agent_status of its
// own. tab_number can only be computed WezTerm-side (ipairs(w:tabs())'s
// visual left-to-right order), so this is the only way to attach a tab
// number to a NOTIFY entry.
func loadPaneTabs() map[string]string {
	data, err := os.ReadFile(paneTabsPath())
	if err != nil {
		return nil
	}
	tabs := make(map[string]string)
	for _, line := range strings.Split(strings.TrimRight(string(data), "\n"), "\n") {
		if line == "" {
			continue
		}
		paneID, tabNumber, ok := strings.Cut(line, "\t")
		if !ok || paneID == "" {
			continue
		}
		tabs[paneID] = tabNumber
	}
	return tabs
}

type model struct {
	entries       []entry
	fileChanges   []fileChange
	notifications []notification
	paneTabs      map[string]string
	width         int
	height        int
	spinner       spinner.Model
	// prevStatus is the status each paneID had as of the previous tick, used
	// by waitTransitions to detect a pane just entering a wait state rather
	// than re-notifying on every tick it stays there.
	prevStatus map[string]string
}

func initialModel() model {
	s := spinner.New()
	s.Spinner = clockSpinner
	entries := loadEntries()
	// Seeded from the startup snapshot, not left empty, so a pane that's
	// already blocked/done when the sidebar launches is treated as the
	// notification baseline rather than a fresh transition worth a ping.
	return model{entries: entries, fileChanges: loadFileChanges(), notifications: loadNotifications(), paneTabs: loadPaneTabs(), spinner: s, prevStatus: statusSnapshot(entries)}
}

// statusSnapshot captures entries' statuses by paneID for comparison against
// the next tick's snapshot.
func statusSnapshot(entries []entry) map[string]string {
	snap := make(map[string]string, len(entries))
	for _, e := range entries {
		snap[e.paneID] = e.status
	}
	return snap
}

// waitTransitions returns the entries whose status just changed into a wait
// state (see waitStatuses) since prev, e.g. working -> blocked. A paneID
// absent from prev (freshly appeared this tick, or not yet seen) is never
// reported: there's no real transition to compare against yet.
func waitTransitions(prev map[string]string, entries []entry) []entry {
	var out []entry
	for _, e := range entries {
		old, ok := prev[e.paneID]
		if !ok || old == e.status || !waitStatuses[e.status] {
			continue
		}
		out = append(out, e)
	}
	return out
}

// notifiedMarkerDir holds one empty marker file per paneID currently
// "claimed" for a wait-state notification. It's shared filesystem state
// (unlike prevStatus, which is per-process memory) so that when several
// agent-sidebar instances are running at once - e.g. one per WezTerm window,
// all polling the same snapshot file - a single pane's transition into a
// wait state gets exactly one notification instead of one per instance.
func notifiedMarkerDir() string {
	return filepath.Join(filepath.Dir(statePath()), "agent-notified")
}

func markerPath(paneID string) string {
	return filepath.Join(notifiedMarkerDir(), paneID)
}

// claimNotification atomically claims the right to notify for paneID's
// current wait-state occurrence, returning whether this call is the one that
// won the claim. os.O_EXCL makes file creation atomic at the filesystem
// level (fails if the marker already exists), so when multiple instances
// race to claim the same pane on the same tick, exactly one succeeds. If the
// marker directory can't even be created, it fails open (returns true)
// rather than silently dropping the notification everywhere.
func claimNotification(paneID string) bool {
	dir := notifiedMarkerDir()
	if err := os.MkdirAll(dir, 0o755); err != nil {
		return true
	}
	f, err := os.OpenFile(markerPath(paneID), os.O_CREATE|os.O_EXCL|os.O_WRONLY, 0o644)
	if err != nil {
		return false
	}
	f.Close()
	return true
}

// pruneNotificationMarkers removes the claim marker for any paneID that's no
// longer in a wait state per current (including one that's disappeared from
// the snapshot entirely), so a later re-entry into blocked/done can be
// claimed - and therefore notified - again instead of staying silently
// suppressed for the rest of the pane's life.
func pruneNotificationMarkers(current map[string]string) {
	entries, err := os.ReadDir(notifiedMarkerDir())
	if err != nil {
		return
	}
	for _, e := range entries {
		if waitStatuses[current[e.Name()]] {
			continue
		}
		os.Remove(markerPath(e.Name()))
	}
}

// focusedPaneID returns the pane ID the user is currently looking at, per
// `wezterm cli list-clients`'s focused_pane_id (distinct from `wezterm cli
// list`'s per-tab is_active, which marks one pane per tab and so can't
// identify the single pane actually on screen across tabs/windows). Returns
// "" if it can't be determined, which simply disables the focus check rather
// than blocking notifications outright. When multiple clients are attached,
// the one with the lowest idle_time is assumed to be the one in front.
func focusedPaneID() string {
	out, err := exec.Command("wezterm", "cli", "list-clients", "--format", "json").Output()
	if err != nil {
		return ""
	}
	var clients []struct {
		FocusedPaneID int `json:"focused_pane_id"`
		IdleTime      struct {
			Secs int64 `json:"secs"`
		} `json:"idle_time"`
	}
	if err := json.Unmarshal(out, &clients); err != nil || len(clients) == 0 {
		return ""
	}
	best := clients[0]
	for _, c := range clients[1:] {
		if c.IdleTime.Secs < best.IdleTime.Secs {
			best = c
		}
	}
	return strconv.Itoa(best.FocusedPaneID)
}

// notifyCmd raises a macOS notification for e via osascript. Values are
// passed as argv items to an `on run argv` handler rather than interpolated
// into the AppleScript source, so an agent/window title containing quotes
// or other AppleScript-meaningful characters can't break out of the script.
func notifyCmd(e entry) tea.Cmd {
	title := fmt.Sprintf("%s %s", statusIcon[e.status], e.agentName)
	message := fmt.Sprintf("%s (tab:%s)", e.title, e.tabNumber)
	return func() tea.Msg {
		exec.Command("osascript", "-e", `on run argv
	display notification (item 2 of argv) with title (item 1 of argv) sound name "Ping"
end run`, title, message).Run()
		return nil
	}
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
		newEntries := loadEntries()
		m.fileChanges = loadFileChanges()
		m.notifications = loadNotifications()
		m.paneTabs = loadPaneTabs()

		newStatus := statusSnapshot(newEntries)
		cmds := []tea.Cmd{tickCmd()}
		// focusedPaneID shells out to `wezterm cli`, so it's only called when
		// there's actually a transition to filter, not on every 500ms tick.
		if transitions := waitTransitions(m.prevStatus, newEntries); len(transitions) > 0 {
			focused := focusedPaneID()
			for _, e := range transitions {
				if e.paneID == focused {
					continue
				}
				// claimNotification is what keeps multiple agent-sidebar
				// instances (e.g. one per WezTerm window) from each firing
				// their own notification for the same transition.
				if claimNotification(e.paneID) {
					cmds = append(cmds, notifyCmd(e))
				}
			}
		}
		pruneNotificationMarkers(newStatus)
		m.prevStatus = newStatus
		m.entries = newEntries

		// A top_level split (see wezterm.lua) doesn't reliably deliver an
		// accurate tea.WindowSizeMsg for the newly-created pane, leaving
		// m.width stuck at some earlier (too-wide) value - which drew the
		// "─" section-divider rule well past the pane's real right edge.
		// Polling the pty's actual size directly on every tick self-corrects
		// regardless of whether WezTerm ever sends that resize event.
		if w, h, err := term.GetSize(os.Stdout.Fd()); err == nil {
			m.width = w
			m.height = h
		}
		return m, tea.Batch(cmds...)
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

// truncate shortens s to fit within max terminal cells, measuring display
// width rather than rune count so wide characters (CJK, emoji - common in
// window titles) can't push a line past the pane's actual column width. A
// rune-count-based truncate let such a line wrap onto a second physical
// terminal row, silently shifting every row index below it out of sync with
// paneIDAtRow()'s click hit-testing.
func truncate(s string, max int) string {
	if max < 1 {
		return s
	}
	return ansi.Truncate(s, max, "…")
}

func (m model) View() string {
	width := m.width
	if width <= 0 {
		width = 30
	}
	agentLines, changeLines, notifyLines := m.sectionHeights()

	// Padded out to its full budget (rather than left as short as its actual
	// content) so the section below always starts at a fixed row, instead of
	// drifting up when this one has few entries. NOTIFY, being last, needs no
	// padding of its own.
	agentSection := m.renderAgentSection(width, agentLines)
	if agentLines > 0 {
		agentSection = padToLines(agentSection, 2+agentLines)
	}
	changeSection := m.renderChangeSection(width, changeLines)
	if changeLines > 0 {
		changeSection = padToLines(changeSection, 2+changeLines)
	}

	var b strings.Builder
	b.WriteString(agentSection)
	b.WriteString(changeSection)
	b.WriteString("\n") // blank line separating AGENT CHANGES from NOTIFY
	b.WriteString(m.renderNotifySection(width, notifyLines))
	return b.String()
}

// padToLines appends blank lines to s (each already ending in "\n") until it
// has target lines total.
func padToLines(s string, target int) string {
	count := strings.Count(s, "\n")
	for ; count < target; count++ {
		s += "\n"
	}
	return s
}

// sectionHeights splits the whole pane height across the three sections:
// AGENT CHANGES and NOTIFY each get a quarter (header included), and the
// agent list gets the remaining half above them - the same 2:1 weighting
// AGENTS:AGENT CHANGES had before NOTIFY existed, extended to a 2:1:1 split.
// One line is reserved up front for the blank line View() inserts between
// AGENT CHANGES and NOTIFY, so that separator doesn't push NOTIFY's body
// past the bottom of the pane. Each result is then reduced by that section's
// own title+rule (2 lines) to get its body-line budget. A height of 0 (not
// yet known, e.g. before the first WindowSizeMsg) means "don't truncate" and
// is returned as 0/0/0.
func (m model) sectionHeights() (agentLines, changeLines, notifyLines int) {
	if m.height <= 0 {
		return 0, 0, 0
	}
	available := m.height - 1
	if available < 0 {
		available = 0
	}
	changeSection := available / 4
	notifySection := available / 4
	agentSection := available - changeSection - notifySection
	return bodyLines(agentSection), bodyLines(changeSection), bodyLines(notifySection)
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
					" " + m.renderIcon(e.status) + agentNameStyle.Render(e.agentName) + " " + dimStyle.Render("(tab:"+e.tabNumber+")"),
					"   " + truncate(e.title, maxTitle),
				},
				paneID: e.paneID,
			})
		}
	}
	return units
}

// agentSectionLineCount returns how many screen lines the AGENTS section
// occupies before AGENT CHANGES starts. When maxLines (its body budget) is set,
// View() pads the section out to fill it exactly, pinning AGENT CHANGES to the
// bottom third of the pane; otherwise (maxLines <= 0, height not yet known)
// it's just however many lines the actual content takes.
func (m model) agentSectionLineCount(width, maxLines int) int {
	if maxLines > 0 {
		return 2 + maxLines
	}
	if len(m.entries) == 0 {
		return 3 // title + rule + "(no agents yet)"
	}
	body := 0
	for _, u := range m.agentUnits(width) {
		body += len(u.lines)
	}
	return 2 + body
}

// changeUnit is one renderable chunk of the AGENT CHANGES body: a 2-line file edit
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
// AGENT CHANGES stream.
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

// changeSectionLineCount mirrors agentSectionLineCount for the AGENT CHANGES
// section, which paneIDAtRow needs to know the total rendered height of now
// that NOTIFY sits below it (AGENT CHANGES used to be the last section, so
// nothing needed its row count before).
func (m model) changeSectionLineCount(width, maxLines int) int {
	if maxLines > 0 {
		return 2 + maxLines
	}
	if len(m.fileChanges) == 0 {
		return 3 // title + rule + "(no changes yet)"
	}
	body := 0
	for _, u := range m.changeUnits(width) {
		body += len(u.lines)
	}
	return 2 + body
}

// notifyUnit is one renderable chunk of the NOTIFY body: a 2-line completed
// `noti` invocation (icon + label, then duration and, on failure, exit
// code). Mirrors agentUnit/changeUnit so rendering and mouse click
// hit-testing share the same layout.
type notifyUnit struct {
	lines  []string
	paneID string
}

func (m model) notifyUnits(width int) []notifyUnit {
	var units []notifyUnit
	for _, n := range m.notifications {
		icon := "✅"
		status := ""
		if n.exitCode != 0 {
			icon = "❌"
			status = removeStyle.Render(fmt.Sprintf(" exit %d", n.exitCode))
		}
		// paneTabs is keyed by pane_id (see loadPaneTabs); a NOTIFY entry with
		// no matching pane (noti run outside WezTerm, or the pane has since
		// closed) simply gets no tab suffix.
		tabSuffix := ""
		if tab := m.paneTabs[n.paneID]; tab != "" {
			tabSuffix = " (tab:" + tab + ")"
		}
		maxLabel := width - 3 - len([]rune(tabSuffix))
		if maxLabel < 4 {
			maxLabel = 4
		}
		units = append(units, notifyUnit{
			lines: []string{
				" " + icon + " " + agentNameStyle.Render(truncate(n.label, maxLabel)) + dimStyle.Render(tabSuffix),
				"   " + dimStyle.Render(n.duration) + status,
			},
			paneID: n.paneID,
		})
	}
	return units
}

// tailNotifyUnits mirrors tailChangeUnits for the NOTIFY stream.
func tailNotifyUnits(units []notifyUnit, maxLines int) []notifyUnit {
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

// paneIDAtRow returns the pane id of the AGENTS or AGENT CHANGES entry rendered at
// absolute screen row y (0-indexed from the very top of the view), or "" if
// y falls on a header, a workspace header, or outside any clickable entry.
// Used to resolve mouse clicks to a pane to focus.
func (m model) paneIDAtRow(y int) string {
	width := m.width
	if width <= 0 {
		width = 30
	}
	agentLines, changeLines, notifyLines := m.sectionHeights()

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

	changeSectionStart := agentSectionRows
	changeSectionRows := m.changeSectionLineCount(width, changeLines)

	if y >= changeSectionStart+2 && y < changeSectionStart+changeSectionRows {
		changeBodyRow := y - changeSectionStart - 2
		line := 0
		for _, u := range tailChangeUnits(m.changeUnits(width), changeLines) {
			if changeBodyRow >= line && changeBodyRow < line+len(u.lines) {
				return u.paneID
			}
			line += len(u.lines)
		}
		return ""
	}

	notifyBodyRow := y - changeSectionStart - changeSectionRows - 1 - 2 // 1 blank line + 2 header lines: "NOTIFY" title + rule
	if notifyBodyRow < 0 {
		return ""
	}
	line := 0
	for _, u := range tailNotifyUnits(m.notifyUnits(width), notifyLines) {
		if notifyBodyRow >= line && notifyBodyRow < line+len(u.lines) {
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

// renderChangeSection renders the "AGENT CHANGES" stream: a tail of the most
// recent file edits, oldest to newest so the latest edit reads at the bottom
// like a scrolling log. Each edit takes two lines (agent name, then file +
// diff stat), so maxLines (0 = unlimited) is halved to get the entry count.
func (m model) renderChangeSection(width, maxLines int) string {
	var b strings.Builder
	b.WriteString(titleStyle.Render("AGENT CHANGES"))
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

// renderNotifySection renders the "NOTIFY" stream: a tail of the most recent
// `noti`-wrapped long-running commands to finish, oldest to newest. Each
// entry takes two lines (icon + label, then duration/exit status), so
// maxLines (0 = unlimited) is halved to get the entry count.
func (m model) renderNotifySection(width, maxLines int) string {
	var b strings.Builder
	b.WriteString(titleStyle.Render("NOTIFY"))
	b.WriteString("\n")
	b.WriteString(dimStyle.Render(strings.Repeat("─", width)))
	b.WriteString("\n")

	if len(m.notifications) == 0 {
		b.WriteString(dimStyle.Render("(no notifications yet)"))
		b.WriteString("\n")
		return b.String()
	}

	for _, u := range tailNotifyUnits(m.notifyUnits(width), maxLines) {
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
		runSetup(os.Args[2:])
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
