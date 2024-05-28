--- lua_add {{{
local winCol = vim.api.nvim_win_get_width(0)
local winRow = vim.api.nvim_win_get_height(0)
local winWidth = math.floor(winCol * 0.95)
local winHeight = math.floor(winRow * 0.8)

vim.fn["ddu#custom#patch_global"]({
  ui = "ff",
  uiParams = {
    ff = {
      autoAction = { name = "preview" },
      startAutoAction = true,

      previewFloating = true,
      previewFloatingBorder = "rounded",
      previewFloatingTitle = "Preview",
      previewSplit = "vertical",
      previewWidth = math.floor(winWidth / 2),
      previewHeight = math.floor(winHeight / 1.5),

      prompt = "> ",
      split = "floating",
      floatingBorder = "rounded",
      floatingTitle = "Data",
      winWidth = math.floor(winWidth / 2),
      winHeight = math.floor(winHeight / 1.5),
      winRow = 3,
      winCol = 5,
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
        ignoredDirectories = { "node_modules", ".git", ".vscode", "dist", "build" },
      },
    },
  },
  kindOptions = {
    file = {
      defaultAction = "open",
    },
  },
})
vim.fn["ddu#custom#patch_local"]("buffer", {
  sources = {
    {
      name = { "buffer" },
      options = {
      },
    },
  },
  kindOptions = {
    buffer = {
      defaultAction = "open",
    },
  },
})
vim.fn["ddu#custom#patch_local"]("grep", {
  sources = {
    {
      name = { "rg" },
    },
  },
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
vim.keymap.set("n", "<Space>b", "<Cmd>call ddu#start(#{name:'buffer'})<CR>")
vim.keymap.set("n", "<Space>gg", "<Cmd>call ddu#start(#{name:'grep'})<CR>")
vim.keymap.set("n", "<Space>g",
  "<Cmd>call ddu#start(#{name:'grep', sources: [#{ name: 'grep', params: #{ input: expand('<cword>') } }]})<CR>")

vim.cmd [[
autocmd User Ddu:ui:ff:openFilterWindow call cmdline#enable()
]]
--- }}}
