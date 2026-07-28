vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = false
  end
})

local function append_staged_diff_to_commit_message()
  local git_root = vim.fn.system({ "git", "rev-parse", "--show-toplevel" }):gsub("%s+$", "")
  if vim.v.shell_error ~= 0 or git_root == "" then
    return
  end

  local diff = vim.fn.system({ "git", "-C", git_root, "diff", "--cached" })
  if vim.v.shell_error ~= 0 or diff == "" then
    return
  end

  local comment_diff = table.concat(vim.tbl_map(function(line)
    return "# " .. line
  end, vim.split(diff, "\n")), "\n")

  vim.api.nvim_buf_set_lines(0, -1, -1, false, vim.split(comment_diff, "\n"))
end

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "COMMIT_EDITMSG",
  callback = append_staged_diff_to_commit_message,
})

vim.cmd [[
  au BufRead,BufNewFile *.tf set filetype=hcl
  autocmd BufNewFile,BufRead *.mdx set filetype=mdx
  autocmd BufNewFile,BufRead *.j2 set filetype=jinja
]]
