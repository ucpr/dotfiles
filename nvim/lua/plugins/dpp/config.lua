local dpp_base = "$XDG_CACHE_HOME/dpp/"
local dpp_repo = dpp_base .. "repos/"
local dpp_src = dpp_repo .. "github.com/Shougo/dpp.vim"
vim.opt.runtimepath:prepend(dpp_src)

local dpp = require("dpp")

local dpp_exts = {
  "github.com/Shougo/dpp-ext-toml",
  "github.com/Shougo/dpp-ext-lazy",
  "github.com/Shougo/dpp-ext-installer",
  "github.com/Shougo/dpp-protocol-git",
}

for _, ext in ipairs(dpp_exts) do
  vim.opt.runtimepath:append(dpp_repo .. ext)
end

vim.g["denops#debug"] = 1 -- note: cmdheight=0 のときはEnterで進めないといけない

if dpp.load_state(dpp_base) then
  local denops_src = dpp_repo .. "github.com/vim-denops/denops.vim"
  vim.opt.runtimepath:prepend(denops_src)

  local dpp_config = "$XDG_CONFIG_HOME/nvim/dpp.ts"
  vim.api.nvim_create_autocmd("User", {
    pattern = "DenopsReady",
    callback = function()
      vim.notify("failed to load_state")
      dpp.make_state(dpp_base, dpp_config)
    end
  })
end

local function install()
  vim.fn["dpp#async_ext_action"]('installer', 'install')
end

local function update()
  vim.fn["dpp#async_ext_action"]('installer', 'update')
end

vim.api.nvim_create_user_command('DppInstall', install, {})
vim.api.nvim_create_user_command('DppUpdate', update, {})
