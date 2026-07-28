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

local AGENT_STATUS_PRIORITY = { blocked = 4, working = 3, done = 2, idle = 1 }
local AGENT_STATUS_ICON = { blocked = "⛔", working = "⚙", done = "✔", idle = "" }
local AGENT_STATUS_COLOR = { blocked = "#ff5555", done = "#2ecc71" }

local function pane_agent_status(pane_info)
	return pane_info.user_vars and pane_info.user_vars.agent_status or nil
end

local function rollup_status(statuses)
	local best, best_pri
	for _, s in ipairs(statuses) do
		local pri = AGENT_STATUS_PRIORITY[s] or 0
		if not best_pri or pri > best_pri then
			best, best_pri = s, pri
		end
	end
	return best
end

local function tab_agent_status(panes)
	local statuses = {}
	for _, p in ipairs(panes) do
		local s = pane_agent_status(p)
		if s then
			table.insert(statuses, s)
		end
	end
	return rollup_status(statuses)
end

local function workspace_agent_status(ws_name)
	local statuses = {}
	for _, w in ipairs(wezterm.mux.all_windows()) do
		if w:get_workspace() == ws_name then
			for _, t in ipairs(w:tabs()) do
				for _, p in ipairs(t:panes()) do
					local uv = p:get_user_vars()
					if uv.agent_status then
						table.insert(statuses, uv.agent_status)
					end
				end
			end
		end
	end
	return rollup_status(statuses)
end

-- Snapshot of every workspace/pane's agent_status, written to disk so that an
-- external process (the sidebar, which has no access to WezTerm's Lua
-- user_vars) can render a vertical status list. One line per PANE (not per
-- tab) so that split tabs with multiple panes/agents are shown individually
-- instead of being collapsed into a single rolled-up row.
local AGENT_STATUS_STATE_DIR = os.getenv("HOME") .. "/.cache/wezterm"
local AGENT_STATUS_STATE_FILE = AGENT_STATUS_STATE_DIR .. "/agent-status.txt"
os.execute('mkdir -p "' .. AGENT_STATUS_STATE_DIR .. '"')

local function write_agent_status_snapshot()
	local ok, err = pcall(function()
		local lines = {}
		for _, ws in ipairs(wezterm.mux.get_workspace_names()) do
			for _, w in ipairs(wezterm.mux.all_windows()) do
				if w:get_workspace() == ws then
					for _, t in ipairs(w:tabs()) do
						for _, p in ipairs(t:panes()) do
							local uv = p:get_user_vars()
							if not uv.agent_sidebar then
								local status = uv.agent_status or ""
								local title = p:get_title() or ""
								table.insert(lines, ws .. "\t" .. status .. "\t" .. title)
							end
						end
					end
				end
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

	local status = tab_agent_status(panes)
	if status and AGENT_STATUS_COLOR[status] then
		background = AGENT_STATUS_COLOR[status]
	end

	local edge_foreground = background

	local icon = status and (AGENT_STATUS_ICON[status] .. " ") or ""
	local title = "   " .. icon .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "

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
	local summary = {}
	for _, ws in ipairs(wezterm.mux.get_workspace_names()) do
		local status = workspace_agent_status(ws)
		if status and status ~= "idle" then
			table.insert(summary, ws .. AGENT_STATUS_ICON[status])
		end
	end
	local summary_text = #summary > 0 and (table.concat(summary, " ") .. "  ") or ""

	write_agent_status_snapshot()

	window:set_right_status(wezterm.format({
		{ Background = { Color = ACTIVE_TAB_BACKGROUND } },
		{ Foreground = { Color = TAB_FOREGROUND } },
		{ Text = "  " .. summary_text .. "ws: " .. window:active_workspace() .. "  " },
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
