-- vim.loader.enable()

local options = {
  -- file encoding
  encoding = "utf-8",
  fileencodings = "utf-8,iso-2022-jp,cp932,sjis,euc-jpset",
  fencs = "utf-8,iso-2022-jp,enc-jp,cp932",
  -- etc
  confirm = true,
  hidden = true,
  foldmethod = "marker", -- 折りたたみ
  display = "uhex",
  writebackup = true,
  infercase = true, -- 補完時に大文字小文字区別しない
  autoread = true,
  backspace = "eol,indent,start",
  signcolumn = "yes",
  mouse = "a",
  -- pastetoggle = "<F5>",
  helplang = "ja",
  -- theme
  spell = false, -- spelunker.vim を使うためfalseにする
  title = false,
  number = true,
  cursorline = false,
  cursorcolumn = false,
  showmatch = true,
  wildmenu = true,
  list = true,
  listchars = {
    tab = "»-",
    eol = "¬",
    extends = "»",
    precedes = "«",
  },
  termguicolors = true,
  cmdheight = 0,
  laststatus = 2,
  showtabline = 2,
  statusline = '%f %y%m %r%h%w%=[%{&fileencoding!=""?&fileencoding:&encoding},%{&ff}] [Pos %02l,%02c] [%p%%/%L]',
  -- pumblend = 30,
  winblend = 5,
  -- syntax
  tabstop = 2,
  shiftwidth = 2,
  smarttab = true,
  smartindent = true,
  expandtab = true,
  -- search
  hlsearch = true,
  ignorecase = true,
  smartcase = true,
  wrapscan = true,
}

vim.opt.completeopt:remove({ "preview" })
vim.opt.clipboard:append({ "unnamedplus" })
for k, v in pairs(options) do
  vim.opt[k] = v
end

--local global_options = {
--  loaded_2html_plugin       = true,
--  loaded_gzip               = true,
--  loaded_tar                = true,
--  loaded_tarPlugin          = true,
--  loaded_zip                = true,
--  loaded_zipPlugin          = true,
--  loaded_vimball            = true,
--  loaded_vimballPlugin      = true,
--  loaded_netrw              = true,
--  loaded_netrwPlugin        = true,
--  loaded_netrwSettings      = true,
--  loaded_netrwFileHandlers  = true,
--  loaded_getscript          = true,
--  loaded_getscriptPlugin    = true,
--  loaded_man                = true,
--  loaded_matchit            = true,
--  loaded_matchparen         = true,
--  loaded_shada_plugin       = true,
--  loaded_spellfile_plugin   = true,
--  loaded_tutor_mode_plugin  = true,
--  did_install_default_menus = true,
--  did_install_syntax_menu   = true,
--  skip_loading_mswin        = true,
--  did_indent_on             = true,
--  did_load_ftplugin         = true,
--  loaded_rrhelper           = true,
--}
--
--for k, v in pairs(global_options) do
--  vim.g[k] = v
--end

-------------

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

vim.g["denops#debug"] = 1  -- note: cmdheight=0 のときはEnterで進めないといけない

if dpp.load_state(dpp_base) then
  local denops_src = dpp_repo .. "github.com/vim-denops/denops.vim"
  vim.opt.runtimepath:prepend(denops_src)

  local dpp_config = "$XDG_CONFIG_HOME/nvim/dpp.ts"
  vim.api.nvim_create_autocmd("User", {
    pattern = "DenopsReady",
    callback = function ()
      vim.notify("failed to load_state")
      dpp.make_state(dpp_base, dpp_config)
    end
  })
end
