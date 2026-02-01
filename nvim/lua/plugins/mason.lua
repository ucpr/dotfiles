return {
  "mason-org/mason.nvim",
  dependencies = {
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    require("mason").setup()

    -- mason-lspconfig v2.0.0+ ではMasonでインストールしたサーバーが自動有効化される
    require("mason-lspconfig").setup({
      ensure_installed = {
        "cssls",
        "eslint",
        "html",
        "jsonls",
        "pyright",
        "tailwindcss",
      },
    })

    require("mason-tool-installer").setup({
      ensure_installed = {
        "stylua", -- lua formatter
        "black",  -- python formatter
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
        ['mason-lspconfig'] = false,
        ['mason-null-ls'] = false,
        ['mason-nvim-dap'] = false,
      },
    })
  end,
}
