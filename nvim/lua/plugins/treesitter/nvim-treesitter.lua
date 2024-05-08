--- lua_source {{{
require 'nvim-treesitter.configs'.setup {
  ensure_installed = { "lua", "go", "python", "bash", "typescript", "yaml", "toml", "json", "vim", "hcl", "rust" },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    -- filesize で現状そんなに問題がないので一旦コメントアウトして様子を見る。問題なかったら完全に消す。
    -- disable = function(_, buf)
    --   local max_filesize = 100 * 1024 -- 100 KB
    --   local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    --   if ok and stats and stats.size > max_filesize then
    --     return true
    --   end
    -- end,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  }
}
--- }}}
