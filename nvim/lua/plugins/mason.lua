return {
  "mason-org/mason.nvim",
  dependencies = {
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    require("mason").setup()

    -- インストールに必要なコマンドが PATH にある場合だけ実行する
    local function has_npm()
      return vim.fn.executable("node") == 1 and vim.fn.executable("npm") == 1
    end

    local function has_go()
      return vim.fn.executable("go") == 1
    end

    -- mason-lspconfig v2.0.0+ ではMasonでインストールしたサーバーが自動有効化される
    require("mason-lspconfig").setup({
      ensure_installed = has_npm() and {
        "cssls",
        "eslint",
        "html",
        "jsonls",
        "pyright",
        "tailwindcss",
      } or {},
    })

    require("mason-tool-installer").setup({
      ensure_installed = {
        "stylua", -- lua formatter
        "black",  -- python formatter
        'lua-language-server',
        { 'vim-language-server', condition = has_npm },
        { 'gopls', condition = has_go },
        { 'gofumpt', condition = has_go },
        { 'golines', condition = has_go },
        { 'gomodifytags', condition = has_go },
        { 'gotests', condition = has_go },
        { 'impl', condition = has_go },
        { 'json-to-struct', condition = has_go },
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
