return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    require("mason").setup()

    require("mason-lspconfig").setup({
      automatic_installation = true,
      ensure_installed = {
        "cssls",
        "eslint",
        "html",
        "jsonls",
        -- "tsserver",
        "pyright",
        "tailwindcss",
      },
    })

    require("mason-tool-installer").setup({
      ensure_installed = {
        "stylua",         -- lua formatter
        "black",          -- python formatter
        'lua-language-server',
        'vim-language-server',
        'gopls',
        'gofumpt',
        'golines',
        'gomodifytags',
        'gotests',
        'impl',
        'json-to-struct',
        'shellcheck',
      },
      integrations = {
        ['mason-lspconfig'] = true,
        ['mason-null-ls'] = false,
        ['mason-nvim-dap'] = false,
      },
    })
  end,
}
