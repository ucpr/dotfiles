vim.loader.enable()

require("settings/opts")
require("settings/disable")
require("settings/autocmd")
-- require("settings/usercmd")
require("settings/keymap")
require("plugins/dpp/config")

require("scripts/go_test")
require("scripts/list_loaded_plugins")

vim.cmd [[
  filetype plugin on
]]
