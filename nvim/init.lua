vim.loader.enable()

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
  -- pumblend = 1,
  -- winblend = 10,
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

  -- telescope
  use "nvim-lua/plenary.nvim"
  use {
    "nvim-telescope/telescope.nvim",
    module = { "telescope" },
    requires = {
      {
        "nvim-telescope/telescope-file-browser.nvim",
        opt = true,
      },
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        opt = true,
      },
      {
        "LinArcX/telescope-env.nvim",
        opt = true,
      },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "make",
        opt = true,
      },
    },
    wants = {
      "telescope-fzf-native.nvim",
      "telescope-file-browser.nvim",
      "telescope-live-grep-args.nvim",
      "telescope-fzf-native.nvim",
      "telescope-env.nvim",
    },
    setup = function()
      local function builtin(name)
        return function(opt)
          return function()
            return require("telescope.builtin")[name](opt or {})
          end
        end
      end

      local function extensions(name, prop)
        return function(opt)
          return function()
            local telescope = require "telescope"
            telescope.load_extension(name)
            return telescope.extensions[name][prop](opt or {})
          end
        end
      end

      vim.keymap.set("n", "<Space>b", builtin("buffers") {})
      vim.keymap.set("n", "<Space>fb", extensions("file_browser", "file_browser") {})
      vim.keymap.set("n", "<Space>ff", builtin("find_files") {})
      vim.keymap.set("n", "<Space>lg", extensions("live_grep_args", "live_grep_args") {})
    end,
    config = function()
      local telescope = require "telescope"
      telescope.setup {
        defaults = {
          file_ignore_patterns = {
            "vendor", "vendor/*", "./vendor", "./vendor/*",
            "node_modules",
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          file_browser = {
            hijack_netrw = true,
          },
          live_grep_args = {
            auto_quoting = true,
          },
        },
      }
      telescope.load_extension("fzf")
    end
  }

  -- etc
  use {
    "navarasu/onedark.nvim",
    event = { "VimEnter" },
    config = function()
      require("onedark").setup {
        style = "warmer",
        transparent = true,           -- Show/hide background
        term_colors = true,           -- Change terminal color as per the selected theme style
        ending_tildes = false,        -- Show the end-of-buffer tildes. By default they are hidden
        cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

        code_style = {
          comments = 'italic',
          keywords = 'none',
          functions = 'none',
          strings = 'none',
          variables = 'none'
        },

        -- Custom Highlights --
        colors = {},     -- Override default colors
        highlights = {}, -- Override highlight groups

        -- Plugins Config --
        diagnostics = {
          darker = true,     -- darker colors for diagnostic
          undercurl = true,  -- use undercurl instead of underline for diagnostics
          background = true, -- use background color for virtual text
        },
      }
      require("onedark").load()
    end
  }
  use { "ntpeters/vim-better-whitespace", event = { "VimEnter" } }
  use {
    "kamykn/spelunker.vim",
    config = function()
      vim.g.enable_spelunker_vim = 1
      vim.g.spelunker_check_type = 2
    end
  }
  use { "simeji/winresizer", event = { "VimEnter" } }
  use { "markonm/traces.vim", opt = true }
  use {
    "cohama/lexima.vim",
    event = { "InsertEnter" },
  }
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
    "numToStr/FTerm.nvim",
    event = { "VimEnter" },
    module = { "FTerm" },
    setup = function()
      vim.keymap.set("n", "T", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')
    end,
    config = function()
      require 'FTerm'.setup({
        border     = 'double',
        dimensions = {
          height = 0.9,
          width = 0.9,
        },
      })
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
  use {
    "nvim-tree/nvim-tree.lua",
    cmd = "NvimTreeToggle",
    setup = function()
      --vim.keymap.set("n", "<C->", '<C-\\><C-n><CMD>NvimTreeToggle<CR>')
    end,
    config = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = true,
        },
      })
    end
  }
  use {
    "almo7aya/openingh.nvim",
    cmd = { "OpenInGHFile", "OpenInGHRepo" },
  }
  use {
    "tpope/vim-fugitive",
    event = "InsertEnter",
  }
  use {
    "lewis6991/gitsigns.nvim",
    event = { "FocusLost", "CursorHold", "VimEnter" },
    config = function()
      require('gitsigns').setup {
        signs                        = {
          add          = { text = '│' },
          change       = { text = '│' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
        signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
        numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir                 = {
          follow_files = true
        },
        attach_to_untracked          = true,
        current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts      = {
          virt_text = true,
          virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
          delay = 1000,
          ignore_whitespace = false,
        },
        current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
        sign_priority                = 6,
        update_debounce              = 100,
        status_formatter             = nil,   -- Use default
        max_file_length              = 40000, -- Disable if file is longer than this (in lines)
        preview_config               = {
          -- Options passed to nvim_open_win
          border = 'double',
          style = 'minimal',
          relative = 'cursor',
          row = 0,
          col = 1
        },
        yadm                         = {
          enable = false
        },
      }
    end
  }
  -- denops
  use "vim-denops/denops.vim"
  use "yuki-yano/fuzzy-motion.vim"
  use "lambdalisue/guise.vim"
  -- use {
  --   "vim-skk/skkeleton",
  --    event = { 'InsertEnter' },
  --   config = function()
  --     vim.cmd [[
  --       "call skkeleton#config({ 'globalJisyo': '/Users/s11591/.skk/SKK-JISYO.L' })

  --       "imap <C-b> <Plug>(skkeleton-toggle)
  --       "cmap <C-b> <Plug>(skkeleton-toggle)
  --     ]]
  --   end,
  -- }
  -- "use {
  -- "  "delphinus/skkeleton_indicator.nvim",
  -- "  config = function()
  -- "    require 'skkeleton_indicator'.setup {}
  -- "  end,
  -- "}

  -- nvim-cmp
  use {
    "hrsh7th/nvim-cmp",
    config = function()
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local feedkey = function(key, mode)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
      end

      local icn = icons()
      local kind_icons = icn.kind

      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = kind_icons[vim_item.kind]

            if entry.source.name == "copilot" then
              vim_item.kind = icn.git.Octoface
              vim_item.kind_hl_group = "CmpItemKindCopilot"
            end

            if entry.source.name == "emoji" then
              vim_item.kind = icn.misc.Smiley
              vim_item.kind_hl_group = "CmpItemKindEmoji"
            end

            if entry.source.name == "crates" then
              vim_item.kind = icn.misc.Package
              vim_item.kind_hl_group = "CmpItemKindCrate"
            end

            if entry.source.name == "lab.quick_data" then
              vim_item.kind = icn.misc.CircuitBoard
              vim_item.kind_hl_group = "CmpItemKindConstant"
            end

            -- NOTE: order matters
            vim_item.menu = ({
              nvim_lsp = "",
              nvim_lua = "",
              luasnip = "",
              buffer = "",
              path = "",
              emoji = "",
            })[entry.source.name]
            return vim_item
          end,
        },
        window = {
          completion = cmp.config.window.bordered({
            border = 'double'
          }),
          documentation = cmp.config.window.bordered({
            border = 'double'
          }),
        },
        sources = {
          { name = "nvim_lsp",                priority = 10 },
          { name = 'vsnip',                   priority = 9 },
          { name = "path",                    priority = 8 },
          { name = "buffer",                  priority = 7 },
          { name = "nvim_lsp_signature_help", priority = 6 },
          { name = "emoji",                   priority = 1 },
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ['<C-l>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ["<CR>"] = cmp.mapping.confirm { select = true },
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif vim.fn["vsnip#available"](1) == 1 then
              feedkey("<Plug>(vsnip-expand-or-jump)", "")
            elseif has_words_before() then
              cmp.complete()
            else
              fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_prev_item()
            elseif vim.fn["vsnip#jumpable"](-1) == 1 then
              feedkey("<Plug>(vsnip-jump-prev)", "")
            end
          end, { "i", "s" }),
        }),
        experimental = {
          ghost_text = true,
        },
      })

      -- Set configuration for specific filetype.
      cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
          { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
        }, {
          { name = 'buffer' },
        })
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })
    end,
    requires = {
      {
        'hrsh7th/cmp-nvim-lsp',
      },
      {
        'hrsh7th/cmp-buffer', event = { 'InsertEnter' }
      },
      {
        'hrsh7th/cmp-path', event = { 'InsertEnter' }
      },
      {
        'hrsh7th/cmp-cmdline', event = { 'ModeChanged' }
      },
      {
        'hrsh7th/cmp-nvim-lsp-signature-help', event = { 'InsertEnter' }
      },
      {
        'hrsh7th/cmp-nvim-lsp-document-symbol', event = { 'InsertEnter' }
      },
      {
        'hrsh7th/cmp-calc', event = { 'InsertEnter' }
      },
      {
        'hrsh7th/cmp-emoji', event = { 'InsertEnter' },
      },
      {
        'onsails/lspkind.nvim', event = { 'InsertEnter' }
      },
      {
        'hrsh7th/cmp-vsnip',
        event = { 'InsertEnter' },
        requires = {
          {
            'hrsh7th/vim-vsnip',
            event = { 'VimEnter' },
            setup = function()
              vim.g.vsnip_snippet_dir = "$HOME/.config/nvim/snippets"
              -- vim.g.vsnip_filetypes = {}
            end,
            config = function()
              vim.cmd [[
                autocmd User PumCompleteDone call vsnip_integ#on_complete_done(g:pum#completed_item)
                autocmd BufWritePre <buffer> lua vim.lsp.buf.format({}, 10000)
                ]]
            end
          },
        },
      },
      {
        "github/copilot.vim",
        event = { "InsertEnter" },
        setup = function()
          vim.g.copilot_filetypes = {
            gitcommit = true,
            markdown = true,
            yaml = true,
            text = true,
          }
          vim.g.copilot_no_tab_map = true
        end,
        config = function()
          local keymap = vim.keymap
          keymap.set(
            "i",
            "<C-c>",
            'copilot#Accept()',
            { silent = true, expr = true, script = true, replace_keycodes = false }
          )
          keymap.set(
            "i",
            "<C-x>",
            '<Plug>(copilot-dismiss)'
          )
          -- keymap("i", "<C-j>", "<Plug>(copilot-next)")
          -- keymap("i", "<C-k>", "<Plug>(copilot-previous)")
          -- keymap("i", "<C-o>", "<Plug>(copilot-dismiss)")
          -- keymap("i", "<C-s>", "<Plug>(copilot-suggest)")

          local function append_diff()
            -- Get the Git repository root directory
            local git_dir = vim.fn.FugitiveGitDir()
            local git_root = vim.fn.fnamemodify(git_dir, ':h')
            -- Get the diff of the staged changes relative to the Git repository root
            local diff = vim.fn.system('git -C ' .. git_root .. ' diff --cached')
            -- Add a comment character to each line of the diff
            local comment_diff = table.concat(vim.tbl_map(function(line)
              return '# ' .. line
            end, vim.split(diff, '\n')), "\n")
            -- Append the diff to the commit message
            vim.api.nvim_buf_set_lines(0, -1, -1, false, vim.split(comment_diff, '\n'))
          end
          vim.cmd [[
            autocmd BufReadPost COMMIT_EDITMSG call lua append_diff()
          ]]
        end,
      },
    },
  }
  -- treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    event = { "VimEnter" },
    run = ":TSUpdate",
    config = function()
      require 'nvim-treesitter.configs'.setup {
        ensure_installed = { "lua", "go", "python", "bash", "typescript", "yaml", "toml", "json", "vim", "hcl" },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          -- filesize で現状そんなに問題がないので一旦コメントアウトして様子を見る。問題なかったら完全に消す。
          -- disable = function(_, buf)
          --   local max_filesize = 100 * 1024 -- 100 KB
          --   local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          --   if ok and stats and stats.size > max_filesize then
          --     return true
          --   end
          -- end,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        }
      }
      vim.cmd("hi TreesitterContextBottom gui=underline guisp=Grey")
    end,
    requires = {
      {
        "m-demare/hlargs.nvim",
        event = { "VimEnter" },
        config = function()
          require('hlargs').setup()
        end
      },
      {
        "nvim-treesitter/nvim-treesitter-context",
        event = { "VimEnter" },
        config = function()
          require 'treesitter-context'.setup {
            patterns = {
              default = {
                'class',
                'function',
                'method',
                'interface',
                'struct',
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
      },
    }
  }

  -- lsp
  use {
    "neovim/nvim-lspconfig",
    requires = {
      {
        "williamboman/mason-lspconfig.nvim",
      },
      {
        "williamboman/mason.nvim",
        module = { "lspconfig" },
      }
    },
    config = function()
      local on_attach = function(client, bufnr)
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

        local opts = { noremap = true, silent = true }
        buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
        buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
        buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
        buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
        buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
        buf_set_keymap('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        buf_set_keymap("n", "gn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
        buf_set_keymap("n", "gf", "<cmd>lua vim.lsp.buf.format { async = true }<CR>", opts)
        buf_set_keymap('n', 'ge', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
        buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
        buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
        buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
        buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
        buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
        buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
        buf_set_keymap("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
        buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
        buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
        buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
      end

      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
          underline = true,
          virtual_text = true,
          signs = true,
          update_in_insert = false,
        }
      )
      -- diagnostic sign setting
      local signs = { Error = "🙅", Warn = "⚠️", Hint = "💡", Info = "ℹ" }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

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
          local opt = {
            on_attach = on_attach,
            capabilities = capabilities,
          }
          if server_name == "gopls" then
            opt.settings = {
              gopls = {
                env = { GOFLAGS = "-tags=integration,wireinject" },
                gofumpt = true,
              },
            }
          elseif server_name == "tsserver" then
            -- package.json と deno.json があるディレクトリ場合は tsserver を使う
            opt.root_dir = nvim_lsp.util.root_pattern("package.json")
          elseif server_name == "denols" then
            opt.root_dir = nvim_lsp.util.root_pattern("deno.json")
          end
          nvim_lsp[server_name].setup(opt)
        end
      }
    end
  }

  -- nvim-dap
  use {
    "mfussenegger/nvim-dap",
    requires = {
      {
        "rcarriga/nvim-dap-ui",
        event = { 'VimEnter' },
        config = function()
          require("dapui").setup({
            icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
            mappings = {
              -- Use a table to apply multiple mappings
              expand = { "<CR>", "<2-LeftMouse>" },
              open = "o",
              remove = "d",
              edit = "e",
              repl = "r",
              toggle = "t",
            },
            -- Expand lines larger than the window
            -- Requires >= 0.7
            expand_lines = vim.fn.has("nvim-0.7") == 1,
            -- Layouts define sections of the screen to place windows.
            -- The position can be "left", "right", "top" or "bottom".
            -- The size specifies the height/width depending on position. It can be an Int
            -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
            -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
            -- Elements are the elements shown in the layout (in order).
            -- Layouts are opened in order so that earlier layouts take priority in window sizing.
            layouts = {
              {
                elements = {
                  -- Elements can be strings or table with id and size keys.
                  { id = "scopes", size = 0.25 },
                  "breakpoints",
                  "stacks",
                  "watches",
                },
                size = 40, -- 40 columns
                position = "left",
              },
              {
                elements = {
                  "repl",
                },
                size = 0.25, -- 25% of total lines
                position = "bottom",
              },
            },
            controls = {
              -- Requires Neovim nightly (or 0.8 when released)
              enabled = true,
              -- Display controls in this element
              element = "repl",
              icons = {
                pause = "",
                play = "",
                step_into = "",
                step_over = "",
                step_out = "",
                step_back = "",
                run_last = "↻",
                terminate = "□",
              },
            },
            floating = {
              max_height = nil,  -- These can be integers or a float between 0 and 1.
              max_width = nil,   -- Floats will be treated as percentage of your screen.
              border = "single", -- Border style. Can be "single", "double" or "rounded"
              mappings = {
                close = { "q", "<Esc>" },
              },
            },
            windows = { indent = 1 },
            render = {
              max_type_length = nil, -- Can be integer or nil.
              max_value_lines = 100, -- Can be integer or nil.
            }
          })
        end,
      },
      {
        "leoluz/nvim-dap-go",
        event = { 'VimEnter' },
        config = function()
          require("dap-go").setup {
            dap_configurations = {
              {
                -- Must be "go" or it will be ignored by the plugin
                type = "go",
                name = "Attach remote",
                mode = "remote",
                request = "attach",
              },
            },
            -- delve configurations
            delve = {
              -- the path to the executable dlv which will be used for debugging.
              -- by default, this is the "dlv" executable on your PATH.
              path = "dlv",
              -- time to wait for delve to initialize the debug session.
              -- default to 20 seconds
              initialize_timeout_sec = 20,
              -- a string that defines the port to start delve debugger.
              -- default to string "${port}" which instructs nvim-dap
              -- to start the process in a random available port
              port = "${port}",
              -- additional args to pass to dlv
              args = {}
            },
          }
        end,
      },
    },
  }

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
keymap.set("n", "<C-q>", ":<C-u>q!<CR>")

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
keymap.set("n", "got", ":<C-u>lua go_test()<CR>")

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

-- {{{ icons

vim.g.use_nerd_icons = false
function icons()
  if vim.fn.has "mac" == 1 or vim.g.use_nerd_icons then
    return {
      kind = {
        -- Text = "",
        Text = "✏︎",
        Method = "m",
        Function = "λ",
        Constructor = "",
        -- Method = "",
        -- Function = "",
        -- Constructor = "",
        Field = "",
        -- Variable = "",
        Variable = "",
        -- Class = "",
        Class = "c",
        Interface = "",
        Module = "",
        -- Module = "",
        Property = "",
        Unit = "",
        -- Value = "",
        Value = "v",
        Enum = "",
        -- Keyword = "",
        Keyword = "",
        Snippet = "",
        -- Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "",
        Event = "",
        Operator = "",
        TypeParameter = "",
      },
      type = {
        -- Array = "",
        Array = "🗃",
        Number = "",
        -- String = "",
        String = "📖",
        Boolean = "蘒",
        -- Object = "",
        Object = "🗂",
      },
      documents = {
        File = "",
        Files = "",
        Folder = "",
        OpenFolder = "",
      },
      git = {
        Add = "",
        Mod = "",
        Remove = "",
        Ignore = "",
        Rename = "",
        Diff = "",
        Repo = "",
        Octoface = "",
      },
      ui = {
        ArrowClosed = "",
        ArrowOpen = "",
        Lock = "",
        Circle = "",
        BigCircle = "",
        BigUnfilledCircle = "",
        Close = "",
        NewFile = "",
        Search = "",
        Lightbulb = "",
        Project = "",
        Dashboard = "",
        History = "",
        Comment = "",
        Bug = "",
        Code = "",
        Telescope = "",
        Gear = "",
        Package = "",
        List = "",
        SignIn = "",
        SignOut = "",
        Check = "",
        Fire = "",
        Note = "",
        BookMark = "",
        Pencil = "",
        -- ChevronRight = "",
        ChevronRight = ">",
        Table = "",
        Calendar = "",
        CloudDownload = "",
      },
      diagnostics = {
        Error = "",
        Warning = "",
        Information = "",
        Question = "",
        Hint = "",
      },
      misc = {
        Robot = "ﮧ",
        Squirrel = "",
        Tag = "",
        Watch = "",
        Smiley = "ﲃ",
        Package = "",
        CircuitBoard = "",
      },
    }
  else
    --   פּ ﯟ   蘒練 some other good icons
    return {
      kind = {
        Text = " ",
        Method = " ",
        Function = " ",
        Constructor = " ",
        Field = " ",
        Variable = " ",
        Class = " ",
        Interface = " ",
        Module = " ",
        Property = " ",
        Unit = " ",
        Value = " ",
        Enum = " ",
        Keyword = " ",
        Snippet = " ",
        Color = " ",
        File = " ",
        Reference = " ",
        Folder = " ",
        EnumMember = " ",
        Constant = " ",
        Struct = " ",
        Event = " ",
        Operator = " ",
        TypeParameter = " ",
        Misc = " ",
      },
      type = {
        Array = " ",
        Number = " ",
        String = " ",
        Boolean = " ",
        Object = " ",
      },
      documents = {
        File = " ",
        Files = " ",
        Folder = " ",
        OpenFolder = " ",
      },
      git = {
        Add = " ",
        Mod = " ",
        Remove = " ",
        Ignore = " ",
        Rename = " ",
        Diff = " ",
        Repo = " ",
        Octoface = " ",
      },
      ui = {
        ArrowClosed = "",
        ArrowOpen = "",
        Lock = " ",
        Circle = " ",
        BigCircle = " ",
        BigUnfilledCircle = " ",
        Close = " ",
        NewFile = " ",
        Search = " ",
        Lightbulb = " ",
        Project = " ",
        Dashboard = " ",
        History = " ",
        Comment = " ",
        Bug = " ",
        Code = " ",
        Telescope = " ",
        Gear = " ",
        Package = " ",
        List = " ",
        SignIn = " ",
        SignOut = " ",
        NoteBook = " ",
        Check = " ",
        Fire = " ",
        Note = " ",
        BookMark = " ",
        Pencil = " ",
        ChevronRight = "",
        Table = " ",
        Calendar = " ",
        CloudDownload = " ",
      },
      diagnostics = {
        Error = " ",
        Warning = " ",
        Information = " ",
        Question = " ",
        Hint = " ",
      },
      misc = {
        Robot = " ",
        Squirrel = " ",
        Tag = " ",
        Watch = " ",
        Smiley = " ",
        Package = " ",
        CircuitBoard = " ",
      },
    }
  end
end

-- }}}

-- vim.cmd [[
--   set runtimepath^=~/.ghq/github.com/ucpr/denops-covcolor
--
--   let g:denops#debug = 1
-- ]]
