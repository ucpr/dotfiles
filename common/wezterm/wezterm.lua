local wezterm = require "wezterm";

local keys = {
  { key = "n", mods = "ALT", action = "ShowLauncher" },
  { key = "t", mods = "ALT", action = "ShowTabNavigator" },

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
  color_scheme = "OneDark (Gogh)",

  use_ime = true,

  font = wezterm.font "Hack",
  font_size = 15.0,

  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },

  keys = keys,

  window_background_opacity = 0.85,
  use_fancy_tab_bar = false,
  -- window_decorations = "NONE",
--  disable_default_key_bindings = true,
}
