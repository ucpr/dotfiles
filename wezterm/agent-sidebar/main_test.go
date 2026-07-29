package main

import (
	"testing"

	"github.com/charmbracelet/x/ansi"
)

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
