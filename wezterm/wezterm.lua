local wezterm = require "wezterm";

local keys = {
  { key = "n", mods = "ALT", action = "ShowLauncher" },
  { key = "s", mods = "ALT", action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" } },
  { key = "v", mods = "ALT", action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { key = "h", mods = "ALT", action = wezterm.action.ActivatePaneDirection "Left" },
  { key = "l", mods = "ALT", action = wezterm.action.ActivatePaneDirection "Right" },
  { key = "k", mods = "ALT", action = wezterm.action.ActivatePaneDirection "Up" },
  { key = "j", mods = "ALT", action = wezterm.action.ActivatePaneDirection "Down" },
}

for i = 1, 9 do
  table.insert(keys, {
    key = tostring(i),
    mods = "ALT",
    action = wezterm.action { ActivateTab = i - 1 },
  })
end

local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_honeycomb
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_honeycomb

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local background = "#5c6d74"
  local foreground = "#FFFFFF"
  local edge_background = "none"

  if tab.is_active then
    background = "#ae8b2d"
    foreground = "#FFFFFF"
  end
  local edge_foreground = background

  local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "

  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_LEFT_ARROW },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)

return {
  color_scheme = 'One Dark (Gogh)',
  use_ime = true,
  font = wezterm.font "Hack Nerd Font",
  font_size = 15.0,
  window_decorations = "RESIZE",
  hide_tab_bar_if_only_one_tab = true,
  -- show_new_tab_button_in_tab_bar = false,
  -- show_close_tab_button_in_tabs = false,
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
