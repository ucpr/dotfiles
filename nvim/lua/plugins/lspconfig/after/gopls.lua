---@type vim.lsp.Config
return {
  settings = {
    gopls = {
      env = {
        GOFLAGS = "-tags=integration,wireinject,!integration",
      },
      gofumpt = true,
      analyses = {
        unusedparams = true,
        shadow = true,
      },
      staticcheck = true,
    },
  },
}
