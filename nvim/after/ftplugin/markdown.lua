-- Neovim 0.12 starts the built-in Treesitter highlighter for Markdown from its
-- bundled ftplugin. Disable it here because some Markdown injections crash the
-- highlighter with "attempt to call method 'range' (a nil value)".
pcall(vim.treesitter.stop, 0)

for _, lhs in ipairs({ "gO", "]]", "[[" }) do
  pcall(vim.keymap.del, "n", lhs, { buffer = 0 })
end
