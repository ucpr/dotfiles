return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
        "windwp/nvim-ts-autotag",
        "m-demare/hlargs.nvim",
        "nvim-treesitter/nvim-treesitter-context",
    },
    opts = {
      highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
      autotag = {
          enable = true,
      },
      ensure_installed = {
          "json",
          "javascript",
          "typescript",
          "tsx",
          "yaml",
          "html",
          "css",
          "markdown",
          "markdown_inline",
          "bash",
          "lua",
          "vim",
          "dockerfile",
          "gitignore",
          "c",
          "rust",
          "go",
      },
      incremental_selection = {
          enable = true,
          keymaps = {
              init_selection = "<C-space>",
              node_incremental = "<C-space>",
              scope_incremental = false,
              node_decremental = "<bs>",
          },
      },
      rainbow = {
          enable = true,
          disable = { "html" },
          extended_mode = false,
          max_file_lines = nil,
      },
      context_commentstring = {
          enable = true,
          enable_autocmd = false,
      },
    },
    config = function()
        require('hlargs').setup()

        vim.cmd("hi TreesitterContextBottom gui=underline guisp=Grey")
        require('treesitter-context').setup {
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
    end,
}
