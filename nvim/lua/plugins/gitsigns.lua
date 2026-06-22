return {
  "lewis6991/gitsigns.nvim",
  config = function()
    local gitsigns = require("gitsigns")
    gitsigns.setup({
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
      numhl = false,     -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false,    -- Toggle with `:Gitsigns toggle_linehl`
      word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      attach_to_untracked = true,
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil,  -- Use default
      max_file_length = 40000, -- Disable if file is longer than this (in lines)
      preview_config = {
        -- Options passed to nvim_open_win
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
      --yadm = {
      --    enable = false,
      --},
    })

    local function complete_git_refs(arg_lead)
      local refs = vim.fn.systemlist({
        "git",
        "for-each-ref",
        "--format=%(refname:short)",
        "refs/heads",
        "refs/remotes",
      })
      if vim.v.shell_error ~= 0 then
        return {}
      end

      return vim.tbl_filter(function(ref)
        return vim.startswith(ref, arg_lead)
      end, refs)
    end

    vim.api.nvim_create_user_command("GitCompareBase", function(args)
      local base = args.args ~= "" and args.args or "origin/main"
      gitsigns.change_base(base, true)
      vim.notify("Gitsigns base: " .. base)
    end, {
      nargs = "?",
      complete = complete_git_refs,
      desc = "Show gitsigns against a base revision",
    })

    vim.api.nvim_create_user_command("GitCompareMain", function()
      gitsigns.change_base("origin/main", true)
      vim.notify("Gitsigns base: origin/main")
    end, {
      desc = "Show gitsigns against origin/main",
    })

    vim.api.nvim_create_user_command("GitCompareReset", function()
      gitsigns.reset_base(true)
      vim.notify("Gitsigns base reset")
    end, {
      desc = "Reset gitsigns base",
    })

    vim.api.nvim_create_user_command("GitPreviewHunkInline", function()
      gitsigns.preview_hunk_inline()
    end, {
      desc = "Preview current gitsigns hunk inline",
    })
  end,
}
