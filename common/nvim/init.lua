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
    statusline = "%f %y%m %r%h%w%=[%{&fileencoding!=''?&fileencoding:&encoding},%{&ff}] [Pos %02l,%02c] [%p%%/%L]",

    -- syntax
    tabstop = 4,
    shiftwidth = 4,
    smarttab = true,
    smartindent = true,
    expandtab = true,

    -- search
    hlsearch = true,
    ignorecase = true,
    smartcase = true,
    wrapscan = true,
}

vim.opt.clipboard:append { 'unnamedplus' }
for k, v in pairs(options) do
    vim.opt[k] = v
end

local fn = vim.fn
local jetpackfile = fn.stdpath('data') .. '/site/pack/jetpack/opt/vim-jetpack/plugin/jetpack.vim'
local jetpackurl = 'https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim'
if fn.filereadable(jetpackfile) == 0 then
    fn.system('curl -fsSLo ' .. jetpackfile .. ' --create-dirs ' .. jetpackurl)
end

vim.cmd('packadd vim-jetpack')
require('jetpack.paq') {
    -- telescope
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-telescope/telescope-file-browser.nvim',
    'nvim-telescope/telescope-live-grep-args.nvim',

    -- etc
    'ntpeters/vim-better-whitespace',
    'kamykn/spelunker.vim',
    'simeji/winresizer',
    'markonm/traces.vim',
    'cohama/lexima.vim',
    'Shougo/context_filetype.vim',
    'joshdick/onedark.vim',
    'mattn/vim-sonictemplate',
    'voldikss/vim-floaterm',

    -- denops
    'vim-denops/denops.vim',
    'yuki-yano/fuzzy-motion.vim',
    'matsui54/denops-signature_help',

    -- ddc
    {
        'Shougo/ddc.vim',
        events = { 'InsertEnter', 'CursorHold', 'CmdlineEnter' },

    },
    'Shougo/ddc-ui-native',
    'Shougo/pum.vim',
    'Shougo/ddc-around',
    'LumaKernel/ddc-file',
    'Shougo/ddc-matcher_head',
    'Shougo/ddc-sorter_rank',
    'Shougo/ddc-converter_remove_overlap',
    'Shougo/ddc-nvim-lsp',
    'matsui54/denops-popup-preview.vim',

    -- lsp
    'neovim/nvim-lspconfig',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',

    -- snip
    'hrsh7th/vim-vsnip',
    'hrsh7th/vim-vsnip-integ',

    -- go
    { 'kyoh86/vim-go-coverage', ft = "go" },
    { 'mattn/vim-goaddtags', ft = "go" },
    { 'mattn/vim-goimpl', ft = "go" },
    { 'mattn/vim-gomod', ft = "go" },
}

local global = vim.g
global.enable_spelunker_vim = 1
global.spelunker_check_type = 2
global.goimports = 1
global.sonictemplate_vim_template_dir = { '$HOME/.vim/template' }

-- floaterm
global.floaterm_autoclose = 1
global.floaterm_title = "🐼"

require("telescope").load_extension("live_grep_args")
require("telescope").load_extension("file_browser")

vim.cmd [[
  colorscheme onedark
]]

local keymap = vim.keymap
keymap.set("n", "s", ":<C-u>FuzzyMotion<CR>")
keymap.set("n", "<C-q>", ":<C-u>q!<CR>")

-- telescope
keymap.set("n", "<Space>b", ":<C-u>Telescope buffers<CR>")
keymap.set("n", "<Space>ff", ":<C-u>Telescope file_browser<CR>")
keymap.set("n", "<Space>r", ":<C-u>Telescope live_grep_args<CR>")

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

vim.api.nvim_create_autocmd('FileType', {
    pattern = { "*.py" },
    command = "set tabstop=4 shiftwidth=4 expandtab",
})
vim.api.nvim_create_autocmd('FileType', {
    pattern = { "*.go" },
    command = "setl ts=4 sw=4 noet",
})

require("denops")
require("nvim-lspconfig")
require("ddc")
require("vim-vsnip")
require("telescope")
