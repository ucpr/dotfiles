return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
        "windwp/nvim-ts-autotag",
        "m-demare/hlargs.nvim",
        "nvim-treesitter/nvim-treesitter-context",
    },
    opts = {
        install_dir = vim.fn.stdpath("data") .. "/site",
        parsers = {
            "bash",
            "css",
            "dockerfile",
            "gitignore",
            "go",
            "html",
            "javascript",
            "json",
            "rust",
            "tsx",
            "typescript",
            "yaml",
        },
        highlight_filetypes = {
            "bash",
            "c",
            "css",
            "dockerfile",
            "gitignore",
            "go",
            "html",
            "javascript",
            "javascriptreact",
            "json",
            "lua",
            "rust",
            "sh",
            "tsx",
            "typescript",
            "typescriptreact",
            "vim",
            "yaml",
        },
    },
    config = function(_, opts)
        local ok, treesitter = pcall(require, "nvim-treesitter")
        if ok and treesitter.setup then
            treesitter.setup {
                install_dir = opts.install_dir,
            }
            vim.api.nvim_create_user_command("TSInstallConfigured", function()
                treesitter.install(opts.parsers)
            end, {})

            local group = vim.api.nvim_create_augroup("UserTreesitterStart", { clear = true })
            vim.api.nvim_create_autocmd("FileType", {
                group = group,
                pattern = opts.highlight_filetypes,
                callback = function(ev)
                    pcall(vim.treesitter.start, ev.buf)
                    vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
        else
            require("nvim-treesitter.configs").setup {
                ensure_installed = opts.parsers,
                highlight = {
                    enable = true,
                    disable = { "markdown" },
                    additional_vim_regex_highlighting = false,
                },
                indent = { enable = true },
            }
        end

        require("nvim-ts-autotag").setup()
        require('hlargs').setup()

        vim.cmd("hi TreesitterContextBottom gui=underline guisp=Grey")
        require('treesitter-context').setup {
          on_attach = function(bufnr)
            return vim.bo[bufnr].filetype ~= "markdown"
          end,
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
