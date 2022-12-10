-- {{{ general options
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
  termguicolors = true,

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

vim.opt.completeopt:remove({ "preview" })
vim.opt.clipboard:append({ "unnamedplus" })
for k, v in pairs(options) do
  vim.opt[k] = v
end

local global_options = {
  loaded_gzip            = 1,
  loaded_tar             = 1,
  loaded_tarPlugin       = 1,
  loaded_zip             = 1,
  loaded_zipPlugin       = 1,
  loaded_rrhelper        = 1,
  loaded_2html_plugin    = 1,
  loaded_vimball         = 1,
  loaded_vimballPlugin   = 1,
  loaded_getscript       = 1,
  loaded_getscriptPlugin = 1,
}
for k, v in pairs(global_options) do
  vim.g[k] = v
end

-- }}}

-- {{{ plugin

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use {
    "lewis6991/impatient.nvim",
    config = function()
      require('impatient')
      require('impatient').enable_profile()
    end
  }

  -- telescope
  use "nvim-lua/plenary.nvim"
  use {
    "nvim-telescope/telescope.nvim",
    requires = {
      {
        "nvim-telescope/telescope-file-browser.nvim",
        config = function()
          require("telescope").load_extension("file_browser")
        end,
      },
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        config = function()
          require("telescope").load_extension("live_grep_args")
        end
      },
      {
        "LinArcX/telescope-env.nvim",
        config = function()
          require("telescope").load_extension("env")
        end
      },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "make",
        config = function()
          require("telescope").load_extension("fzf")
        end
      },
    },
    config = function()
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
    end
  }

  -- etc
  use {
    "luisiacc/gruvbox-baby",
    config = function()
      vim.cmd [[
        colorscheme gruvbox-baby
        " 検索時のハイライトの色を変更
        hi Search guibg=peru guifg=wheat
      ]]
    end
  }
  use { "ntpeters/vim-better-whitespace", opt = true }
  use {
    "kamykn/spelunker.vim",
    setup = function()
      vim.g.enable_spelunker_vim = 1
      vim.g.spelunker_check_type = 2
    end
  }
  use { "simeji/winresizer", opt = true }
  use { "markonm/traces.vim", opt = true }
  use "cohama/lexima.vim"
  use "Shougo/context_filetype.vim"
  use {
    "mattn/vim-sonictemplate",
    cmd = {
      "Template",
    },
    setup = function()
      vim.g.sonictemplate_vim_template_dir = { "$HOME/.vim/template" }
    end
  }
  use {
    "voldikss/vim-floaterm",
    cmd = {
      "FloatermToggle",
    },
    setup = function()
      vim.g.floaterm_autoclose = 1
      vim.g.floaterm_title = "🐼"
    end
  }
  use {
    "unblevable/quick-scope",
    config = function()
      vim.cmd [[
        augroup qs_colors
          autocmd!
          autocmd ColorScheme * highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
          autocmd ColorScheme * highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
        augroup END
      ]]
    end,
    setup = function()
      vim.g.qs_hi_priority = 2
      vim.g.qs_max_chars = 80
      vim.g.qs_lazy_highlight = 0
      vim.g.qs_buftype_blacklist = { "terminal", "nofile" }
    end,
  }

  -- denops
  use "vim-denops/denops.vim"
  use "yuki-yano/fuzzy-motion.vim"
  use {
    "matsui54/denops-signature_help",
    config = function()
      vim.fn["signature_help#enable"]()
    end
  }
  use {
    "matsui54/denops-popup-preview.vim",
    config = function()
      vim.fn["popup_preview#enable"]()
    end
  }

  -- ddc
  --use {"Shougo/ddc.vim", }
  use {
    "Shougo/ddc.vim",
    event = { "InsertEnter", "CursorHold", "CmdlineEnter" },
    requires = {
      "Shougo/ddc-ui-native",
      "Shougo/pum.vim",
      "Shougo/ddc-around",
      "LumaKernel/ddc-file",
      "Shougo/ddc-matcher_head",
      "Shougo/ddc-sorter_rank",
      "Shougo/ddc-converter_remove_overlap",
      "Shougo/ddc-nvim-lsp",
    },
    config = function()
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
    end
  }
  -- treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function()
      require 'nvim-treesitter.configs'.setup {
        ensure_installed = { "lua", "go", "python", "bash", "typescript", "yaml", "toml", "json", "vim" },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          -- disable = { "c", "rust" },
          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        }
      }
      vim.cmd("hi TreesitterContextBottom gui=underline guisp=Grey")
    end,
    requires = {
      "nvim-treesitter/nvim-treesitter-context",
      config = function()
        require 'treesitter-context'.setup {
          patterns = {
            default = {
              'class',
              'function',
              'method',
              --            'for',
              --            'while',
              --            'if',
              --            'switch',
              --            'case',
              'interface',
              'struct',
              --            'enum',
            },

            haskell = {
              'adt'
            },
            rust = {
              'impl_item',

            },
            terraform = {
              'block',
              'object_elem',
              'attribute',
            },
            markdown = {
              'section',
            },
            json = {
              'pair',
            },
            typescript = {
              'export_statement',
            },
            yaml = {
              'block_mapping_pair',
            },
          },
        }
      end
    }
  }
  --use "nvim-treesitter/nvim-treesitter-context"

  -- lsp
  use {
    "neovim/nvim-lspconfig",
    config = function()
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

      local nvim_lsp = require("lspconfig")
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
        function(server_name)
          if server_name == "gopls" then
            nvim_lsp[server_name].setup {
              on_attach = on_attach,
              settings = {
                gopls = {
                  env = { GOFLAGS = "-tags=integration,wireinject" },
                },
              },
            }
          else
            nvim_lsp[server_name].setup {
              on_attach = on_attach,
            }
          end
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
    end
  }
  use "williamboman/mason.nvim"
  use "williamboman/mason-lspconfig.nvim"

  -- snip
  use {
    "hrsh7th/vim-vsnip",
    config = function()
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
    end
  }
  use "hrsh7th/vim-vsnip-integ"

  -- go
  use { "kyoh86/vim-go-coverage", ft = "go" }
  use { "mattn/vim-goaddtags", ft = "go" }
  use { "mattn/vim-goimpl", ft = "go" }
  use { "mattn/vim-gomod", ft = "go" }
  use {
    "mattn/vim-goimports",
    ft = "go",
    setup = function()
      vim.g.goimports = 1
    end,
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

--- }}}

-- {{{ keybind

local keymap = vim.keymap
keymap.set("n", "s", ":<C-u>FuzzyMotion<CR>")
keymap.set("n", "<C-c>", ":<C-u>q!<CR>")

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

-- custom script
keymap.set("n", "gt", ":<C-u>lua go_test()<CR>")

-- }}}

-- {{{ autocmd

vim.api.nvim_create_user_command("Sterm", function() vim.cmd(":split | resize 20 | term ") end, {})
vim.api.nvim_create_user_command("Vterm", function() vim.cmd [[ :vsplit | term ]] end, {})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "*.py" },
  command = "set tabstop=4 shiftwidth=4 expandtab",
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "*.go" },
  command = "setl ts=4 sw=4 noet",
})

vim.cmd [[
  autocmd FileType go setl ts=4 sw=4 noet
]]

-- }}}

-- {{{ go-test
function get_split_window_type()
  local id = vim.fn.win_getid()
  local width = vim.fn.winwidth(id)
  local height = vim.fn.winheight(id) * 2.1

  if height > width then
    return "split"
  else
    return "vsplit"
  end
end

function get_cursor_byte_offset()
  return vim.fn.line2byte(vim.fn.line('.')) + (vim.fn.col('.') - 2)
end

function go_test()
  local test_info = vim.fn.json_decode(
    vim.fn.system(
      string.format("go-test-name -pos %d -file %s", get_cursor_byte_offset(), vim.fn.expand("%"))
    )
  )
  for _, v in ipairs(vim.api.nvim_list_bufs()) do
    if vim.fn.bufname(v) == "vim-go-test-func" then
      vim.fn.execute(string.format("bwipe! %d", v))
    end
  end

  local dir = vim.fn.expand("%:p:h")
  if #(test_info["sub_test_names"]) > 0 then
    -- TODO: Investigate why sub test name is nil when accessed by sub_test_name[0]
    local sub_test_name = ""
    for _, v in ipairs(test_info["sub_test_names"]) do
      sub_test_name = v
    end
    cmd = string.format(
      "go test -coverprofile='/tmp/go-coverage.out' -json -v -count=1 -v -race -run='^%s$'/'^%s$' $(go list %s) 2>&1 | tee /tmp/gotest.log | gotestfmt"
      , test_info.test_func_name, sub_test_name, dir
    )
  else
    cmd = string.format(
      "go test -coverprofile='/tmp/go-coverage.out' -json -v -count=1 -v -race -run='^%s$' $(go list %s) 2>&1 | tee /tmp/gotest.log | gotestfmt"
      , test_info.test_func_name, dir
    )
  end

  local st = get_split_window_type()
  vim.fn.execute(string.format("%s gotest", st))

  if split == "split" then
    vim.cmd [[
      execute(printf('resize %s', floor(&lines * 0.3)))
    ]]
  end

  vim.call("termopen", cmd)
  vim.cmd [[
    setlocal bufhidden=delete
    setlocal noswapfile
    setlocal nobuflisted
    file vim-go-test-func
    wincmd p
  ]]
end

-- }}}
