package main

import (
	"path/filepath"
	"testing"

	"github.com/charmbracelet/x/ansi"
)

// withNotifiedMarkerDir points notifiedMarkerDir() (via statePath()'s
// AGENT_SIDEBAR_STATE_FILE override) at a fresh temp dir, so these tests
// never touch the real ~/.cache/wezterm/agent-notified/.
func withNotifiedMarkerDir(t *testing.T) {
	t.Helper()
	t.Setenv("AGENT_SIDEBAR_STATE_FILE", filepath.Join(t.TempDir(), "agent-status.txt"))
}

// claimNotification is the cross-process guard against every agent-sidebar
// instance (one per WezTerm window, all polling the same snapshot) firing
// its own notification for the same pane transition: only the first caller
// to claim a given paneID should win.
func TestClaimNotificationOnlyFirstCallerWins(t *testing.T) {
	withNotifiedMarkerDir(t)

	if !claimNotification("42") {
		t.Fatal("first claimNotification(42) = false, want true")
	}
	if claimNotification("42") {
		t.Fatal("second claimNotification(42) = true, want false (already claimed)")
	}
	if !claimNotification("99") {
		t.Fatal("claimNotification(99) = false, want true (distinct pane, no prior claim)")
	}
}

// pruneNotificationMarkers must clear a claim once its pane leaves the wait
// state (or disappears from the snapshot) - otherwise a pane that cycles
// blocked -> working -> blocked again would only ever notify once, for the
// rest of its life.
func TestPruneNotificationMarkersReclaimsAfterLeavingWaitState(t *testing.T) {
	withNotifiedMarkerDir(t)

	claimNotification("1") // still blocked - claim survives
	claimNotification("2") // back to working - claim should be cleared
	claimNotification("3") // pane closed, absent from current - claim should be cleared

	pruneNotificationMarkers(map[string]string{"1": "blocked", "2": "working"})

	if claimNotification("1") {
		t.Error("claimNotification(1) = true after prune, want false: pane 1 is still blocked, claim must survive")
	}
	if !claimNotification("2") {
		t.Error("claimNotification(2) = false after prune, want true: pane 2 left the wait state, claim should be reclaimable")
	}
	if !claimNotification("3") {
		t.Error("claimNotification(3) = false after prune, want true: pane 3 is gone from current, claim should be reclaimable")
	}
}

// waitTransitions must fire exactly once on entering a wait state, not on
// every tick spent there, and never for a pane it has no prior status for -
// otherwise a pane already blocked/done when the sidebar starts up would
// wrongly notify on the very first tick.
func TestWaitTransitions(t *testing.T) {
	prev := map[string]string{
		"1": "working", // about to transition into a wait state
		"2": "blocked", // already in a wait state - no re-notify
		"3": "working", // stays working - no transition
	}
	entries := []entry{
		{paneID: "1", status: "blocked"},
		{paneID: "2", status: "blocked"},
		{paneID: "3", status: "working"},
		{paneID: "4", status: "done"}, // no prior status recorded - not reported
	}

	got := waitTransitions(prev, entries)

	if len(got) != 1 || got[0].paneID != "1" {
		t.Fatalf("waitTransitions(...) = %v, want exactly the pane 1 -> blocked transition", got)
	}
}

// truncate must bound display width, not rune count: a title with wide
// (CJK/emoji) characters that fits within maxTitle runes can still overflow
// the pane's actual column width, wrapping onto a second physical terminal
// row and desyncing paneIDAtRow()'s click hit-testing for every row below it.
func TestTruncateBoundsDisplayWidthNotRuneCount(t *testing.T) {
	title := "⠐ agent-sidebar タブのフォーカス時の表示改善"
	maxTitle := 27

	got := truncate(title, maxTitle)

	if w := ansi.StringWidth(got); w > maxTitle {
		t.Errorf("truncate(%q, %d) = %q, display width %d exceeds budget %d", title, maxTitle, got, w, maxTitle)
	}
}
