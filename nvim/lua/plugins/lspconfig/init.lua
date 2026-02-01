-- カスタムパスから個別LSP設定を読み込むヘルパー
local function load_lsp_config(server_name)
  local ok, config = pcall(require, "plugins.lspconfig.after." .. server_name)
  if ok then
    return config
  end
  return {}
end

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          { path = "luvit-meta/library", words = { "vim%.uv" } },
          "lazy.nvim",
          "plenary.nvim",
          { path = "wezterm-types", mods = { "wezterm" } },
        },
      },
    },
  },
  config = function()
    -- Diagnostic signs
    local signs = { Error = "🙅", Warn = "⚠️", Hint = "💡", Info = "🙋" }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    -- 全サーバー共通設定
    vim.lsp.config("*", {
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
    })

    -- 個別サーバー設定
    vim.lsp.config("gopls", load_lsp_config("gopls"))

    -- LspAttach でキーマップを設定
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
      callback = function(ev)
        local opts = { buffer = ev.buf, noremap = true, silent = true }

        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gvd", "<cmd>vsp<CR><cmd>lua vim.lsp.buf.definition()<CR>", opts)
        vim.keymap.set("n", "gsd", "<cmd>sp<CR><cmd>lua vim.lsp.buf.definition()<CR>", opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "gn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "gf", function()
          vim.lsp.buf.format({ async = true })
        end, opts)
        vim.keymap.set("n", "ge", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set("n", "<space>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

        -- format on save
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client and client.server_capabilities.documentFormattingProvider then
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("LspFormat_" .. ev.buf, { clear = true }),
            buffer = ev.buf,
            callback = function()
              vim.lsp.buf.format({ async = true })
            end,
          })
        end
      end,
    })

    -- LSPサーバーを有効化
    vim.lsp.enable({
      "gopls",
      "lua_ls",
      "cssls",
      "eslint",
      "html",
      "jsonls",
      "pyright",
      "tailwindcss",
      "vimls",
    })
  end,
}
