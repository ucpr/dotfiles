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

return {
  color_scheme = 'One Dark (Gogh)',
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
  -- front_end = "WebGpu",
}
