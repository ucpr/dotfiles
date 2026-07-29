local wezterm = require("wezterm")

local keys = {
	{ key = "n", mods = "ALT", action = "ShowLauncher" },
	{ key = "s", mods = "ALT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "v", mods = "ALT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "h", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "l", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "k", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "j", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Down") },
	{
		key = "a",
		mods = "ALT",
		action = wezterm.action_callback(function(window, pane)
			-- Toggle: if the sidebar is already open in this tab, close it;
			-- otherwise open it. The sidebar self-identifies via the
			-- `agent_sidebar` user var (see agent-sidebar/main.go).
			for _, p in ipairs(window:active_tab():panes()) do
				if p:get_user_vars().agent_sidebar then
					-- CloseCurrentPane closes whichever pane is actually focused at
					-- call time, ignoring the pane passed to perform_action. Activate
					-- the sidebar first so it unambiguously *is* the current pane,
					-- otherwise this closes whatever pane the user was really on.
					p:activate()
					window:perform_action(wezterm.action.CloseCurrentPane({ confirm = false }), p)
					return
				end
			end

			window:perform_action(
				wezterm.action.SplitPane({
					direction = "Left",
					size = { Cells = 30 },
					command = {
						-- WezTerm spawns this directly (not via the user's shell), so PATH is
						-- just the system default and doesn't include mise's `go` shim. mise
						-- is activated from .zshrc, which only loads for interactive shells,
						-- so both -i and -l are required (login alone is not enough).
						args = {
							"/bin/zsh",
							"-i",
							"-l",
							"-c",
							-- `go run <absolute-dir>` resolves go.mod from $PWD, not from that
							-- directory, so it fails unless we cd into it first.
							"cd "
								.. os.getenv("HOME")
								.. "/.ghq/github.com/ucpr/dotfiles/wezterm/agent-sidebar && exec go run .",
						},
					},
				}),
				pane
			)
		end),
	},
}

for i = 1, 9 do
	table.insert(keys, {
		key = tostring(i),
		mods = "ALT",
		action = wezterm.action({ ActivateTab = i - 1 }),
	})
end

-- local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_honeycomb
-- local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_honeycomb

local TAB_BACKGROUND = "#1E2127"
local ACTIVE_TAB_BACKGROUND = "#ae8b2d"
local TAB_FOREGROUND = "#FFFFFF"

-- Snapshot of every workspace/pane's agent_status, written to disk so that an
-- external process (the sidebar, which has no access to WezTerm's Lua
-- user_vars) can render a vertical status list. One line per PANE (not per
-- tab) so that split tabs with multiple panes/agents are shown individually
-- instead of being collapsed into a single rolled-up row.
local AGENT_STATUS_STATE_DIR = os.getenv("HOME") .. "/.cache/wezterm"
local AGENT_STATUS_STATE_FILE = AGENT_STATUS_STATE_DIR .. "/agent-status.txt"
os.execute('mkdir -p "' .. AGENT_STATUS_STATE_DIR .. '"')

-- Reports whether p's foreground process still looks like a live agent CLI,
-- as opposed to the plain shell the pane drops back to once the agent exits.
-- Bash-tool subprocesses spawned by Claude Code / Codex don't take over the
-- pty's foreground process group (verified via `ps -o tpgid` against a live
-- session), so this stays true for the whole session and only flips once
-- the agent process itself actually exits - unlike agent_status, which only
-- updates when a hook happens to fire (SessionEnd, e.g.) and never notices
-- e.g. a Ctrl+C kill.
local function has_live_agent_process(p)
	local ok, proc = pcall(function()
		return p:get_foreground_process_name()
	end)
	if not ok or not proc then
		return false
	end
	local lower = proc:lower()
	return lower:find("claude", 1, true) ~= nil or lower:find("codex", 1, true) ~= nil
end

-- A single missed check doesn't necessarily mean the agent exited - some
-- tool invocations (an interactive ssh/pty-allocating command, or the brief
-- fork/exec window right as the CLI starts up) can transiently change what
-- looks like the foreground process. Removing an entry only for it to
-- reappear a tick later churns the AGENTS list's row layout, which is what
-- was causing sidebar ghosting and mouse clicks landing on the wrong pane.
-- Requiring a few consecutive misses before actually dropping a pane keeps
-- the "disappear when the agent exits" behavior while making that churn
-- rare instead of routine.
local AGENT_MISSING_GRACE_TICKS = 3
local agent_missing_ticks = {}

local function pane_agent_is_live(p)
	local pane_id = p:pane_id()
	if has_live_agent_process(p) then
		agent_missing_ticks[pane_id] = nil
		return true
	end
	local misses = (agent_missing_ticks[pane_id] or 0) + 1
	agent_missing_ticks[pane_id] = misses
	return misses <= AGENT_MISSING_GRACE_TICKS
end

local function write_agent_status_snapshot()
	local ok, err = pcall(function()
		local lines = {}
		local seen_pane_ids = {}
		for _, ws in ipairs(wezterm.mux.get_workspace_names()) do
			for _, w in ipairs(wezterm.mux.all_windows()) do
				if w:get_workspace() == ws then
					for tab_number, t in ipairs(w:tabs()) do
						for _, p in ipairs(t:panes()) do
							local uv = p:get_user_vars()
							seen_pane_ids[p:pane_id()] = true
							-- Only panes that have an actual agent_status (i.e. an agent
							-- hook has fired there at some point) AND still have that
							-- agent's process alive are included, so the sidebar doesn't
							-- list plain shells or panes an agent has already exited.
							if not uv.agent_sidebar and uv.agent_status and pane_agent_is_live(p) then
								local agent_name = uv.agent_name or ""
								local title = p:get_title() or ""
								table.insert(
									lines,
									ws
										.. "\t"
										.. uv.agent_status
										.. "\t"
										.. agent_name
										.. "\t"
										.. tab_number
										.. "\t"
										.. title
										.. "\t"
										.. p:pane_id()
								)
							end
						end
					end
				end
			end
		end
		-- Drop bookkeeping for panes that no longer exist at all (closed,
		-- not just agent-exited), so agent_missing_ticks doesn't grow
		-- unboundedly over a long-running wezterm session.
		for pane_id in pairs(agent_missing_ticks) do
			if not seen_pane_ids[pane_id] then
				agent_missing_ticks[pane_id] = nil
			end
		end

		local f = io.open(AGENT_STATUS_STATE_FILE, "w")
		if f then
			f:write(table.concat(lines, "\n") .. "\n")
			f:close()
		end
	end)
	if not ok then
		wezterm.log_warn("write_agent_status_snapshot failed: " .. tostring(err))
	end
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local background = TAB_BACKGROUND
	local foreground = TAB_FOREGROUND
	local edge_background = "none"

	if tab.is_active then
		background = ACTIVE_TAB_BACKGROUND
		foreground = TAB_FOREGROUND
	end

	local edge_foreground = background

	local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "

	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		-- { Text = SOLID_LEFT_ARROW },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		-- { Text = SOLID_RIGHT_ARROW },
	}
end)

wezterm.on("update-right-status", function(window, _)
	write_agent_status_snapshot()

	window:set_right_status(wezterm.format({
		{ Background = { Color = ACTIVE_TAB_BACKGROUND } },
		{ Foreground = { Color = TAB_FOREGROUND } },
		{ Text = "  ws: " .. window:active_workspace() .. "  " },
	}))
end)

wezterm.on("user-var-changed", function(window, pane, name, value)
	if name == "switch_workspace" then
		local workspace, cwd = value:match("^([^\t]+)\t([^\t]*)")
		if not workspace then
			workspace = value
			cwd = ""
		end
		if not workspace or workspace == "" then
			return
		end

		if pcall(wezterm.mux.set_active_workspace, workspace) then
			return
		end

		window:perform_action(
			wezterm.action.SwitchToWorkspace({
				name = workspace,
				spawn = {
					cwd = cwd ~= "" and cwd or nil,
				},
			}),
			pane
		)
		return
	end

	if name == "agent_status" then
		local agent_name = pane:get_user_vars().agent_name or "Agent"
		local tab_title = pane:get_title() or "Unknown Tab"
		if value == "blocked" then
			window:toast_notification(agent_name, "承認待ち: " .. tab_title, nil, 4000)
		elseif value == "done" then
			window:toast_notification(agent_name, "完了: " .. tab_title, nil, 4000)
		end
		write_agent_status_snapshot()
		return
	end
end)

return {
	color_scheme = "One Dark (Gogh)",
	use_ime = true,
	font = wezterm.font("JetBrains Mono"),
	font_size = 15.0,
	window_decorations = "RESIZE",
	hide_tab_bar_if_only_one_tab = false,
	show_new_tab_button_in_tab_bar = false,
	show_close_tab_button_in_tabs = false,
	window_frame = {
		inactive_titlebar_bg = "none",
		active_titlebar_bg = "none",
	},
	colors = {
		tab_bar = {
			inactive_tab_edge = "none",
		},
	},
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	keys = keys,
	window_background_opacity = 1,
	-- front_end = "WebGpu",
}
