return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    "ahmedkhalf/project.nvim",
    "stevearc/aerial.nvim",
  },
  config = function()
    require("telescope").setup({
      extensions = {
        fzf = {
          fuzzy = true,                   -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true,    -- override the file sorter
          case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
        }
      }
    })
    require('telescope').load_extension('fzf')
    require('telescope').load_extension('projects')
    require("telescope").load_extension("aerial")

    local keymap = vim.keymap

    keymap.set("n", "<Space>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<Space>g", "<cmd>Telescope live_grep<cr>", { desc = "Fuzzy find recent files" })
    keymap.set("n", "<Space>b", "<cmd>Telescope buffers<cr>", { desc = "Find string in cwd" })
    keymap.set("n", "<Space>gs", "<cmd>Telescope git_status<cr>", { desc = "Find string under cursor in cwd" })
    keymap.set("n", "<Space>gc", "<cmd>Telescope git commits<cr>", { desc = "Find todos" })
  end,
}
