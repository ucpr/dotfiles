--- lua_add {{{
vim.fn["ddu#custom#patch_global"]({
  ui = "ff",
  uiParams = {
    ff = {
      filterFloatingPosition = "bottom",
      filterSplitDirection = "floating",
      floatingBorder = "rounded",
      previewFloating = true,
      previewFloatingBorder = "rounded",
      previewFloatingTitle = "Preview",
      previewSplit = "horizontal",
      prompt = "> ",
      split = "floating",
      startFilter = true,
    }
  },
  sourceOptions = {
    _ = {
      matchers = { "matcher_fzf" },
      sorters = { "sorter_fzf" },
      converters = { "converter_devicon" },
      ignoreCase = true,
    },
  },
  kindOptions = {
    action = {
      defaultAction = "do",
    },
  },
})
vim.fn["ddu#custom#patch_local"]("file_recursive", {
  sources = {
    {
      name = { "file_rec" },
      options = {
        converters = {
          "converter_devicon",
        },
      },
      params = {
        ignoredDirectories = { "node_modules", ".git", ".vscode" },
      },
    },
  },
  kindOptions = {
    file = {
      defaultAction = "open",
    },
  },
})
vim.fn["ddu#custom#patch_local"]("grep", {
  sourceParams = {
    rg = {
      args = { "--column", "--no-heading", "--color", "never" },
    },
  },
  kindOptions = {
    file = {
      defaultAction = "open",
    },
  },
  uiParams = {
    ff = {
      startFilter = false,
      previewFloating = false,
      previewSplit = "vertical",
    },
  },
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "ddu-ff",
  callback = function()
    local opts = { noremap = true, silent = true, buffer = true }
    vim.keymap.set({ "n" }, "q", [[<Cmd>call ddu#ui#do_action("quit")<CR>]], opts)
    vim.keymap.set({ "n" }, "a", [[<Cmd>call ddu#ui#do_action("chooseAction")<CR>]], opts)
    vim.keymap.set({ "n" }, "<Cr>", [[<Cmd>call ddu#ui#do_action("itemAction")<CR>]], opts)
    vim.keymap.set({ "n" }, "<C-v>", [[<Cmd>call ddu#ui#do_action("itemAction", {'params': {'command': 'vsplit'}})<CR>]],
      opts)
    vim.keymap.set({ "n" }, "<C-x>", [[<Cmd>call ddu#ui#do_action("itemAction", {'params': {'command': 'split'}})<CR>]],
      opts)
    vim.keymap.set({ "n" }, "i", [[<Cmd>call ddu#ui#do_action("openFilterWindow")<CR>]], opts)
    vim.keymap.set({ "n" }, "P", [[<Cmd>call ddu#ui#do_action("togglePreview")<CR>]], opts)
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "ddu-ff-filter",
  callback = function()
    local opts = { noremap = true, silent = true, buffer = true }
    vim.keymap.set({ "n", "i" }, "<CR>", [[<Esc><Cmd>close<CR>]], opts)
  end,
})
vim.fn["ddu#custom#patch_local"]("colorscheme", {
  sources = {
    {
      name = { "colorscheme" },
    },
  },
  kindOptions = {
    colorscheme = {
      defaultAction = "set",
    }
  }
})

vim.keymap.set("n", "<Space>ff", "<Cmd>call ddu#start(#{name:'file_recursive'})<CR>")
vim.keymap.set("n", "<Space>g",
  "<Cmd>call ddu#start(#{name:'grep', sources: [#{ name: 'rg', params: #{ input: expand('<cword>') } }]})<CR>")
--- }}}
