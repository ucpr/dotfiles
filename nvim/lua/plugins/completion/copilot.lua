--- lua_source {{{
vim.g.copilot_filetypes = {
  gitcommit = true,
  markdown = true,
  yaml = true,
  text = true,
}
vim.g.copilot_no_tab_map = true

vim.keymap.set(
  "i",
  "<C-c>",
  'copilot#Accept()',
  { silent = true, expr = true, script = true, replace_keycodes = false }
)
vim.keymap.set(
  "i",
  "<C-x>",
  '<Plug>(copilot-dismiss)'
)
--- }}}

--- lua_post_source {{{
local function append_diff()
  -- Get the Git repository root directory
  local git_dir = vim.fn.FugitiveGitDir()
  local git_root = vim.fn.fnamemodify(git_dir, ':h')
  -- Get the diff of the staged changes relative to the Git repository root
  local diff = vim.fn.system('git -C ' .. git_root .. ' diff --cached')
  -- Add a comment character to each line of the diff
  local comment_diff = table.concat(vim.tbl_map(function(line)
    return '# ' .. line
  end, vim.split(diff, '\n')), "\n")
  -- Append the diff to the commit message
  vim.api.nvim_buf_set_lines(0, -1, -1, false, vim.split(comment_diff, '\n'))
end
vim.cmd [[
  autocmd BufReadPost COMMIT_EDITMSG call lua append_diff()
]]
--- }}}
