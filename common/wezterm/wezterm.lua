local wezterm = require "wezterm";

local keys = {
  { key = "n", mods = "ALT", action = "ShowLauncher" },
  -- { key = "t", mods = "ALT", action = "ShowTabNavigator" },

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

return {
  -- color_scheme = "OneDark (Gogh)",
  colors = {
    foreground = "#d3c6aa",
    background = "#2b3339",
    cursor_bg = "#d3c6aa",
    cursor_border = "#d3c6aa",
    cursor_fg = "#2b3339",
    selection_bg = "#d3c6aa",
    selection_fg = "#2b3339",
    ansi = { "#4b565c", "#e67e80", "#a7c080", "#dbbc7f", "#7fbbb3", "#d699b6", "#83c092", "#d3c6aa" },
    brights = { "#4b565c", "#e67e80", "#a7c080", "#dbbc7f", "#7fbbb3", "#d699b6", "#83c092", "#d3c6aa" },
  },

  use_ime = true,

  font = wezterm.font "Hack Nerd Font",
  font_size = 15.0,

  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },

  keys = keys,

  window_background_opacity = 0.9,
  -- use_fancy_tab_bar = false,
  -- window_decorations = "NONE",
  -- disable_default_key_bindings = true,
}
