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
  pastetoggle = "<F5>",
  helplang = "ja",

  -- theme
  title = false,
  number = true,
  cursorline = true,
  cursorcolumn = true,
  showmatch = true,
  wildmenu = true,
  list = true,
  listchars = {
    tab = "»-",
    eol = "¬",
    extends = "»",
    precedes = "«",
  },

  cmdheight = 0,
  laststatus = 2,
  showtabline = 2,
  statusline = '%f %y%m %r%h%w%=[%{&fileencoding!=""?&fileencoding:&encoding},%{&ff}] [Pos %02l,%02c] [%p%%/%L]',

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

vim.opt.clipboard:append { "unnamedplus" }
for k, v in pairs(options) do
  vim.opt[k] = v
end

local fn = vim.fn
local jetpackfile = fn.stdpath("data") .. "/site/pack/jetpack/opt/vim-jetpack/plugin/jetpack.vim"
local jetpackurl = "https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim"
if fn.filereadable(jetpackfile) == 0 then
  fn.system("curl -fsSLo " .. jetpackfile .. " --create-dirs " .. jetpackurl)
end

vim.cmd("packadd vim-jetpack")
require("jetpack.paq") {
  -- telescope
  "nvim-lua/plenary.nvim",
  "nvim-telescope/telescope.nvim",
  "nvim-telescope/telescope-file-browser.nvim",
  "nvim-telescope/telescope-live-grep-args.nvim",
  "LinArcX/telescope-env.nvim",
  { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },

  -- etc
  "ntpeters/vim-better-whitespace",
  "kamykn/spelunker.vim",
  "simeji/winresizer",
  "markonm/traces.vim",
  "cohama/lexima.vim",
  "Shougo/context_filetype.vim",
  "joshdick/onedark.vim",
  "mattn/vim-sonictemplate",
  "voldikss/vim-floaterm",

  -- denops
  "vim-denops/denops.vim",
  "yuki-yano/fuzzy-motion.vim",
  "matsui54/denops-signature_help",

  -- ddc
  {
    "Shougo/ddc.vim",
    events = { "InsertEnter", "CursorHold", "CmdlineEnter" },

  },
  "Shougo/ddc-ui-native",
  "Shougo/pum.vim",
  "Shougo/ddc-around",
  "LumaKernel/ddc-file",
  "Shougo/ddc-matcher_head",
  "Shougo/ddc-sorter_rank",
  "Shougo/ddc-converter_remove_overlap",
  "Shougo/ddc-nvim-lsp",
  "matsui54/denops-popup-preview.vim",

  -- lsp
  "neovim/nvim-lspconfig",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",

  -- snip
  "hrsh7th/vim-vsnip",
  "hrsh7th/vim-vsnip-integ",

  -- go
  { "kyoh86/vim-go-coverage", ft = "go" },
  { "mattn/vim-goaddtags", ft = "go" },
  { "mattn/vim-goimpl", ft = "go" },
  { "mattn/vim-gomod", ft = "go" },
}

-- denops
vim.fn["popup_preview#enable"]()

local global = vim.g
global.enable_spelunker_vim = 1
global.spelunker_check_type = 2
global.goimports = 1
global.sonictemplate_vim_template_dir = { "$HOME/.vim/template" }

-- floaterm
global.floaterm_autoclose = 1
global.floaterm_title = "🐼"

require("telescope").load_extension("live_grep_args")
require("telescope").load_extension("file_browser")
require("telescope").load_extension("fzf")
require("telescope").load_extension("env")

vim.cmd [[
  colorscheme onedark
]]

local keymap = vim.keymap
keymap.set("n", "s", ":<C-u>FuzzyMotion<CR>")
keymap.set("n", "<C-q>", ":<C-u>q!<CR>")

-- telescope
keymap.set("n", "<Space>b", ":<C-u>Telescope buffers<CR>")
keymap.set("n", "<Space>fb", ":<C-u>Telescope file_browser<CR>")
keymap.set("n", "<Space>ff", ":<C-u>Telescope find_files<CR>")
keymap.set("n", "<Space>lg", ":<C-u>Telescope live_grep_args<CR>")

-- floaterm
keymap.set("n", "T", ":<C-u>FloatermToggle<CR>")

-- buffer
keymap.set("n", ",", ":<C-u>bprev<CR>")
keymap.set("n", ".", ":<C-u>bnext<CR>")

-- tab
keymap.set("n", "tl", ":<C-u>tabn<CR>")
keymap.set("n", "th", ":<C-u>tabp<CR>")
keymap.set("n", "<C-t>", ":<C-u>tabnew<CR>")

-- window
keymap.set("n", "<C-h>", "<C-w>h")
keymap.set("n", "<C-j>", "<C-w>j")
keymap.set("n", "<C-k>", "<C-w>k")
keymap.set("n", "<C-l>", "<C-w>l")

-- terminal mode
keymap.set("t", "<C-@>", "<C-\\><C-n>")
keymap.set("t", "<C-q>", "exit<CR>")
keymap.set("t", "<Esc>", "<C-\\><C-n>")

vim.api.nvim_create_user_command("Sterm", function() vim.cmd [[ :split | resize 20 | term ]] end, {})
vim.api.nvim_create_user_command("Vterm", function() vim.cmd [[ :vsplit | term ]] end, {})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "*.py" },
  command = "set tabstop=4 shiftwidth=4 expandtab",
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "*.go" },
  command = "setl ts=4 sw=4 noet",
})

-- {{{ telescope
local lga_actions = require("telescope-live-grep-args.actions")
require("telescope").setup {
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
    },
    file_browser = {
      hijack_netrw = true,
      mappings = {
        ["i"] = {
          -- your custom insert mode mappings
        },
        ["n"] = {
          -- your custom normal mode mappings
        },
      },
    },
    live_grep_args = {
      auto_quoting = true, -- enable/disable auto-quoting
      -- define mappings, e.g.
      mappings = { -- extend mappings
        i = {
          ["<C-k>"] = lga_actions.quote_prompt(),
          ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
        },
      },
    },
  },
}
-- }}}

-- {{{ vim-vsnip
vim.cmd [[
let g:vsnip_snippet_dir = "$HOME/.vim/vsnip"
autocmd User PumCompleteDone call vsnip_integ#on_complete_done(g:pum#completed_item)

"function s:trigger_completedone()
"  let info = pum#complete_info()
"  let complete_item = info.items[info.selected]
"  call vsnip_integ#on_complete_done(complete_item)
"  if vsnip#available(1)
"    return "\<Plug>(vsnip-expand-or-jump)"
"  else
"    return "\<Tab>"
"  "return "\<Ignore>"
"endfunction
"
"imap <expr> <Tab> <SID>trigger_completedone()
"smap <expr> <Tab> <SID>trigger_completedone()
" imap <expr> <Tab>   vsnip#available(1)  ? "<Plug>(vsnip-expand-or-jump)" : "<Tab>"
" smap <expr> <Tab>   vsnip#available(1)  ? "<Plug>(vsnip-expand-or-jump)" : "<Tab>"
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? "<Plug>(vsnip-jump-prev)"      : "<S-Tab>"
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? "<Plug>(vsnip-jump-prev)"      : "<S-Tab>"

imap <expr> <C-j> vsnip#expandable() ? "<Plug>(vsnip-expand)" : "<C-j>"
smap <expr> <C-j> vsnip#expandable() ? "<Plug>(vsnip-expand)" : "<C-j>"
imap <expr> <C-f> vsnip#jumpable(1)  ? "<Plug>(vsnip-jump-next)" : "<C-f>"
smap <expr> <C-f> vsnip#jumpable(1)  ? "<Plug>(vsnip-jump-next)" : "<C-f>"
imap <expr> <C-b> vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<C-b>"
smap <expr> <C-b> vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<C-b>"
let g:vsnip_filetypes = {}

autocmd BufWritePre <buffer> lua vim.lsp.buf.format({}, 10000)
]]
-- }}}

--{{{ ddc.vim
vim.cmd [[
call ddc#custom#patch_global("ui", "native")
call ddc#custom#patch_global("sources", [
    \ "around",
    \ "file",
    \ "vsnip",
    \ "nvim-lsp"
    \ ])
call ddc#custom#patch_global("sourceOptions", {
    \ "_": {
    \   "matchers": ["matcher_head"],
    \   "sorters": ["sorter_rank"],
    \   "converters": ["converter_remove_overlap"],
    \ },
    \ "around": {"mark": "Around"},
    \ "file": {
    \   "mark": "file",
    \   "isVolatile": v:true,
    \   "forceCompletionPattern": "\S/\S*",
    \ },
    \ "vsnip": {
    \   "mark": "vsnip",
    \   "minAutoCompleteLength": 1,
    \ },
    \ "nvim-lsp": {
    \   "mark": "LSP",
    \   "forceCompletionPattern": "\.\w*|:\w*|->\w*",
    \ },
    \ })

call ddc#custom#patch_global("sourceParams", {
   \ "around": {"maxSize": 500},
   \ })

" Use Customized labels
call ddc#custom#patch_global("sourceParams", {
   \ "nvim-lsp": { "kindLabels": { "Class": "c" } },
   \ })

" pum.vim setting
call ddc#custom#patch_global("completionMenu", "pum.vim")
inoremap <silent><expr> <TAB>
\ pumvisible() ? "<C-n>" :
\ (col(".") <= 1 <Bar><Bar> getline(".")[col(".") - 2] =~# "\s") ?
\ "<TAB>" : ddc#map#manual_complete()

" <S-TAB>: completion back.
inoremap <expr><S-TAB>  pumvisible() ? "<C-p>" : "<C-h>"

inoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>
inoremap <C-n>   <Cmd>call pum#map#select_relative(+1)<CR>
inoremap <C-p>   <Cmd>call pum#map#select_relative(-1)<CR>
inoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
inoremap <C-e> <Cmd>call pum#map#cancel()<CR>

autocmd User PumCompleteDone call vsnip_integ#on_complete_done(g:pum#completed_item)

call ddc#enable()
]]

--}}}

--{{{ nvim-lspconfig
local nvim_lsp = require("lspconfig")
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  local opts = { noremap = true, silent = true }
  buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
  buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  buf_set_keymap("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
  buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
  buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
  buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})
require("mason-lspconfig").setup()
require("mason-lspconfig").setup_handlers {
  function(server_name) -- default handler (optional)
    require("lspconfig")[server_name].setup {
      on_attach = on_attach,
    }
  end
}


function OrgImports(wait_ms)
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { "source.organizeImports" } }
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
      else
        vim.lsp.buf.execute_command(r.command)
      end
    end
  end
end

vim.cmd [[
  autocmd User PumCompleteDone call vsnip_integ#on_complete_done(g:pum#completed_item)
]]
--}}
