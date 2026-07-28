return {
  "folke/sidekick.nvim",
  dependencies = { "folke/snacks.nvim" },
  opts = {
    -- Copilot LSP is only needed for Next Edit Suggestions.
    -- Keep Sidekick as an AI CLI terminal wrapper.
    nes = {
      enabled = false,
    },
    cli = {
      picker = "snacks",
      tools = {
        claude_resume = {
          cmd = { "claude", "--resume" },
        },
        claude_continue = {
          cmd = { "claude", "--continue" },
        },
      },
    },
  },
  keys = {
    { "<leader>a", nil, desc = "AI/Sidekick" },
    {
      "<leader>aa",
      function()
        require("sidekick.cli").toggle()
      end,
      desc = "Toggle Sidekick CLI",
    },
    {
      "<leader>ac",
      function()
        require("sidekick.cli").toggle({ name = "claude", focus = true })
      end,
      desc = "Toggle Claude",
    },
    {
      "<leader>af",
      function()
        require("sidekick.cli").focus({ name = "claude" })
      end,
      mode = { "n", "t", "i", "x" },
      desc = "Focus Claude",
    },
    {
      "<leader>ar",
      function()
        require("sidekick.cli").toggle({ name = "claude_resume", focus = true })
      end,
      desc = "Resume Claude",
    },
    {
      "<leader>ad",
      function()
        require("sidekick.cli").close()
      end,
      desc = "Close Sidekick CLI",
    },
    {
      "<leader>aC",
      function()
        require("sidekick.cli").toggle({ name = "claude_continue", focus = true })
      end,
      desc = "Continue Claude",
    },
    {
      "<leader>ab",
      function()
        require("sidekick.cli").send({ name = "claude", msg = "{file}" })
      end,
      desc = "Send current file to Claude",
    },
    {
      "<leader>as",
      function()
        require("sidekick.cli").send({ name = "claude", msg = "{selection}" })
      end,
      mode = "x",
      desc = "Send selection to Claude",
    },
    {
      "<leader>ap",
      function()
        require("sidekick.cli").prompt({ name = "claude" })
      end,
      mode = { "n", "x" },
      desc = "Select Sidekick prompt",
    },
    {
      "<C-.>",
      function()
        require("sidekick.cli").focus()
      end,
      mode = { "n", "t", "i", "x" },
      desc = "Sidekick Focus",
    },
  },
}
