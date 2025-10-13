vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = false
  end
})

vim.cmd [[
  au BufRead,BufNewFile *.tf set filetype=hcl
  autocmd BufNewFile,BufRead *.mdx set filetype=mdx
  autocmd BufNewFile,BufRead *.j2 set filetype=jinja
]]
